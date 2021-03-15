// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:veggieseasons/data/veggie.dart';
import 'package:sqlite/sqlite.dart';

void main() {
  final database = Database('data/veggies.db');

  final result = database.query('''
      select *
      from Veggies
      ;''');

  for (final row in result) {
    print('''
id:                 ${row['id']}
name:               ${row['name']}
image:              ${row['image']}
category:           ${VeggieCategory.values[row['category'] as int]}
description:        ${row['description']}
accentColor:        ${row['accentColor']}
seasons:            ${(row['seasons'] as String).split(',').map((i) => Season.values[int.parse(i)])}
vitaminAPercentage: ${row['vitaminAPercentage']}
vitaminCPercentage: ${row['vitaminCPercentage']}
servingSize:        ${row['servingSize']}
caloriesPerServing: ${row['caloriesPerServing']}
isFavorite:         ${row['isFavorite'] == 1}
    ''');
  }

  database.close();
}
