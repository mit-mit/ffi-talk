// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:veggieseasons/data/db_veggie_provider.dart';
import 'package:veggieseasons/data/veggie.dart';

class AppState extends ChangeNotifier {
  AppState();

  List<Veggie> get favoriteVeggies => DbVeggieProvider.favorites();

  Veggie getVeggie(int? id) => DbVeggieProvider.veggie(id!);

  List<Veggie> searchVeggies(String? terms) =>
      DbVeggieProvider.search(searchTerm: terms!);

  void setFavorite(int? id, bool isFavorite) {
    DbVeggieProvider.setFavorite(id!, isFavorite);
    notifyListeners();
  }

  /// Used in tests to set the season independent of the current date.
  static Season? debugCurrentSeason;
}
