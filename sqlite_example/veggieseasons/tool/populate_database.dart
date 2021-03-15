// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:veggieseasons/data/local_veggie_provider.dart';
import 'package:sqlite/sqlite.dart';

void main() {
  final database = Database('data/veggies.db');

  database.execute('drop table if exists Veggies;');

  database.execute('''
      create table Veggies (
        id integer primary key,
        name text not null,
        image text not null,
        category integer not null,
        description text nult null,
        accentColor integer not null,
        seasons text not null,
        vitaminAPercentage integer not null,
        vitaminCPercentage integer not null,
        servingSize text not null,
        caloriesPerServing integer not null,
        isFavorite integer not null
      );''');

  LocalVeggieProvider.veggies.forEach((veggie) {
    database.execute('''
      insert into Veggies (
        id,
        name,
        image,
        category,
        description,
        accentColor,
        seasons,
        vitaminAPercentage,
        vitaminCPercentage,
        servingSize,
        caloriesPerServing,
        isFavorite
      )
      values (
        ${veggie.id},
        '${veggie.name.escape()}',
        '${veggie.image.escape()}',
        ${veggie.category.index},
        '${veggie.description.escape()}',
        ${veggie.accentColor},
        '${veggie.seasons.map((s) => s.index.toString()).join(",")}',
        ${veggie.vitaminAPercentage},
        ${veggie.vitaminCPercentage},
        '${veggie.servingSize.escape()}',
        ${veggie.caloriesPerServing},
        ${veggie.isFavorite ? 1 : 0}
      );''');
  });

  database.close();
}

extension on String {
  String escape() {
    return replaceAll("'", "''");
  }
}
