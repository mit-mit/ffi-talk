# Veggie Seasons

This is a copy of the [Flutter sample Veggie Seasons](https://github.com/flutter/samples/tree/master/veggieseasons).

For demonstration purposes this app is modified to be backed by a
SQLite database using `dart:ffi` for MacOS.

The SQLite implementation is in `lib/data/db_veggie_provider.dart` and
`lib/data/app_state.dart` was modified to use the `DbVeggieProvider` instead
of the `LocalVeggieProvider`.

## Steps for running the app.

Create and populate the database with:

```
$ dart tool/populate_database.dart
```

Check that the database was populated correctly:

```
$ dart tool/read_database.dart
id:                 1
name:               Apples
image:              assets/images/apple.jpg
...
``` 

Run the Flutter app:

```
$ flutter run
```
