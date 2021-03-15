// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:sqlite/src/database/closable_iterator.dart';
import 'package:sqlite/src/third_party/sqlite3/generated_bindings.dart';

final sqlite = SQLite3(DynamicLibrary.open('libsqlite3.dylib'));

/// [Database] represents an open connection to a SQLite database.
///
/// All functions against a database may throw [SQLiteError].
///
/// This database interacts with SQLite synchonously.
class Database {
  late Pointer<sqlite3> _database;

  /// Open a database located at the file [path].
  Database(String path,
      [int flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE]) {
    final directory = File.fromUri(Uri.file(path)).parent;
    directory.createSync(recursive: true);

    final dbOut = calloc<Pointer<sqlite3>>();
    final pathC = path.toNativeUtf8();
    final resultCode =
        sqlite.sqlite3_open_v2(pathC.cast(), dbOut, flags, nullptr);
    _database = dbOut.value;
    calloc.free(dbOut);
    calloc.free(pathC);

    if (resultCode != SQLITE_OK) {
      // Even if 'open' fails, sqlite3 will still create a database object. We
      // can just destroy it.
      final exception = _loadError(resultCode);
      close();
      throw exception;
    }
  }

  /// Close the database.
  ///
  /// This should only be called once on a database unless an exception is
  /// thrown. It should be called at least once to finalize the database and
  /// avoid resource leaks.
  void close() {
    final resultCode = sqlite.sqlite3_close_v2(_database);
    if (resultCode != SQLITE_OK) {
      throw _loadError(resultCode);
    }
  }

  /// Execute a query, discarding any returned rows.
  void execute(String statement) {
    final statementOut = calloc<Pointer<sqlite3_stmt>>();
    final statementC = statement.toNativeUtf8();
    var resultCode = sqlite.sqlite3_prepare_v2(
        _database, statementC.cast(), -1, statementOut, nullptr);
    final statementPointer = statementOut.value;
    calloc.free(statementOut);
    calloc.free(statementC);

    while (resultCode == SQLITE_ROW || resultCode == SQLITE_OK) {
      resultCode = sqlite.sqlite3_step(statementPointer);
    }
    sqlite.sqlite3_finalize(statementPointer);
    if (resultCode != SQLITE_DONE) {
      throw _loadError(resultCode);
    }
  }

  /// Evaluate a query and return the resulting rows as an iterable.
  Result query(String statement) {
    final statementOut = calloc<Pointer<sqlite3_stmt>>();
    final statementC = statement.toNativeUtf8();
    var resultCode = sqlite.sqlite3_prepare_v2(
        _database, statementC.cast(), -1, statementOut, nullptr);
    final statementPointer = statementOut.value;
    calloc.free(statementOut);
    calloc.free(statementC);

    if (resultCode != SQLITE_OK) {
      sqlite.sqlite3_finalize(statementPointer);
      throw _loadError(resultCode);
    }

    final columnIndices = <String, int>{};
    final columnCount = sqlite.sqlite3_column_count(statementPointer);
    for (var i = 0; i < columnCount; i++) {
      final columnName = sqlite
          .sqlite3_column_name(statementPointer, i)
          .cast<Utf8>()
          .toDartString();
      columnIndices[columnName] = i;
    }

    return Result._(this, statementPointer, columnIndices);
  }

  SQLiteException _loadError(int errorCode) {
    final errorMessage =
        sqlite.sqlite3_errmsg(_database).cast<Utf8>().toDartString();
    final errorCodeExplanation =
        sqlite.sqlite3_errstr(errorCode).cast<Utf8>().toDartString();
    return SQLiteException(
        '$errorMessage (Code $errorCode: $errorCodeExplanation)');
  }
}

/// [Result] represents a [Database.query]'s result and provides an [Iterable]
/// interface for the results to be consumed.
///
/// Please note that this iterator should be [close]d manually if not all [Row]s
/// are consumed.
class Result extends IterableBase<Row> implements ClosableIterable<Row> {
  final ClosableIterator<Row> _iterator;

  Result._(
    Database database,
    Pointer<sqlite3_stmt> statement,
    Map<String, int> columnIndices,
  ) : _iterator = _ResultIterator(statement, columnIndices);

  @override
  void close() => _iterator.close();

  @override
  ClosableIterator<Row> get iterator => _iterator;
}

class _ResultIterator implements ClosableIterator<Row> {
  final Pointer<sqlite3_stmt> _statement;
  final Map<String, int> _columnIndices;

  Row? _currentRow;
  bool _closed = false;

  _ResultIterator(this._statement, this._columnIndices);

  @override
  bool moveNext() {
    if (_closed) {
      throw SQLiteException('The result has already been closed.');
    }
    _currentRow?._setNotCurrent();
    final stepResult = sqlite.sqlite3_step(_statement);
    if (stepResult == SQLITE_ROW) {
      _currentRow = Row._(_statement, _columnIndices);
      return true;
    } else {
      close();
      return false;
    }
  }

  @override
  Row get current {
    if (_closed) {
      throw SQLiteException('The result has already been closed.');
    }
    return _currentRow!;
  }

  @override
  void close() {
    _currentRow?._setNotCurrent();
    _closed = true;
    sqlite.sqlite3_finalize(_statement);
  }
}

class Row {
  final Pointer<sqlite3_stmt> _statement;
  final Map<String, int> _columnIndices;

  bool _isCurrentRow = true;

  Row._(this._statement, this._columnIndices);

  /// Reads column [columnName].
  dynamic operator [](String columnName) {
    _checkIsCurrentRow();

    final columnIndex = _columnIndices[columnName]!;

    final dynamicType =
        _typeFromCode(sqlite.sqlite3_column_type(_statement, columnIndex));

    switch (dynamicType) {
      case _Type.integer:
        return sqlite.sqlite3_column_int(_statement, columnIndex);
      case _Type.text:
        return sqlite
            .sqlite3_column_text(_statement, columnIndex)
            .cast<Utf8>()
            .toDartString();
      case _Type.nullType:
        return null;
      default:
    }
  }

  void _checkIsCurrentRow() {
    if (!_isCurrentRow) {
      throw Exception(
          'This row is not the current row, reading data from the non-current'
          ' row is not supported by sqlite.');
    }
  }

  void _setNotCurrent() {
    _isCurrentRow = false;
  }
}

_Type _typeFromCode(int code) {
  switch (code) {
    case SQLITE_INTEGER:
      return _Type.integer;
    case SQLITE_FLOAT:
      return _Type.float;
    case SQLITE_TEXT:
      return _Type.text;
    case SQLITE_BLOB:
      return _Type.blob;
    case SQLITE_NULL:
      return _Type.nullType;
  }
  throw Exception('Unknown type [$code]');
}

enum _Type { integer, float, text, blob, nullType }

class SQLiteException {
  final String message;
  SQLiteException(this.message);

  @override
  String toString() => message;
}
