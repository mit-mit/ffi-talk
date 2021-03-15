// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:veggieseasons/data/veggie.dart';
import 'package:sqlite/sqlite.dart';

class DbVeggieProvider {
  static final _root =
      Directory.fromUri(Platform.script).parent.uri.toFilePath();
  static final database = Database('${_root}data/veggies.db');

  static List<Veggie> search({
    String searchTerm = '',
    int page = 0,
    int resultsPerPage = 15,
  }) {
    final statement = '''
      select *
      from Veggies
      where (
        name like '%${searchTerm.escape()}%' or
        description like '%${searchTerm.escape()}%'
      )
      limit ${resultsPerPage * page}, $resultsPerPage
      ;''';

    final result = database.query(statement);

    return result
        .map((row) => Veggie(
              id: row['id'] as int,
              name: row['name'] as String,
              description: row['description'] as String,
              image: row['image'] as String,
            ))
        .toList();
  }

  static List<Veggie> favorites() {
    final result = database.query('''
      select *
      from Veggies
      where isFavorite = 1
      ;''');

    return result.map(_toVeggie).toList();
  }

  static Veggie veggie(int id) {
    final result = database.query('''
      select *
      from Veggies
      where id = $id
      ;''');

    return result.map(_toVeggie).first;
  }

  static void setFavorite(int id, bool isFavorite) {
    database.execute('''
      update Veggies
      set isFavorite = ${isFavorite ? 1 : 0}
      where id = $id
      ;''');
  }
}

Veggie _toVeggie(Row row) => Veggie(
    id: row['id'] as int,
    name: row['name'] as String,
    image: row['image'] as String,
    category: VeggieCategory.values[row['category'] as int],
    description: row['description'] as String,
    accentColor: row['accentColor'] as int,
    seasons: (row['seasons'] as String)
        .split(',')
        .map((i) => Season.values[int.parse(i)])
        .toList(),
    vitaminAPercentage: row['vitaminAPercentage'] as int,
    vitaminCPercentage: row['vitaminCPercentage'] as int,
    servingSize: row['servingSize'] as String,
    caloriesPerServing: row['caloriesPerServing'] as int,
    trivia: [],
    isFavorite: row['isFavorite'] as int == 1);

extension on String {
  String escape() {
    return replaceAll("'", "''");
  }
}
