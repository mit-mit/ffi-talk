// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

enum VeggieCategory {
  allium,
  berry,
  citrus,
  cruciferous,
  fern,
  flower,
  fruit,
  fungus,
  gourd,
  leafy,
  legume,
  melon,
  root,
  stealthFruit,
  stoneFruit,
  tropical,
  tuber,
  vegetable,
}

enum Season {
  winter,
  spring,
  summer,
  autumn,
}

class Trivia {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  const Trivia(this.question, this.answers, this.correctAnswerIndex);
}

const Map<VeggieCategory, String> veggieCategoryNames = {
  VeggieCategory.allium: 'Allium',
  VeggieCategory.berry: 'Berry',
  VeggieCategory.citrus: 'Citrus',
  VeggieCategory.cruciferous: 'Cruciferous',
  VeggieCategory.fern: 'Technically a fern',
  VeggieCategory.flower: 'Flower',
  VeggieCategory.fruit: 'Fruit',
  VeggieCategory.fungus: 'Fungus',
  VeggieCategory.gourd: 'Gourd',
  VeggieCategory.leafy: 'Leafy',
  VeggieCategory.legume: 'Legume',
  VeggieCategory.melon: 'Melon',
  VeggieCategory.root: 'Root vegetable',
  VeggieCategory.stealthFruit: 'Stealth fruit',
  VeggieCategory.stoneFruit: 'Stone fruit',
  VeggieCategory.tropical: 'Tropical',
  VeggieCategory.tuber: 'Tuber',
  VeggieCategory.vegetable: 'Vegetable',
};

const Map<Season, String> seasonNames = {
  Season.winter: 'Winter',
  Season.spring: 'Spring',
  Season.summer: 'Summer',
  Season.autumn: 'Autumn',
};

class Veggie {
  Veggie({
    this.id = 0,
    this.name = 'No name',
    this.image = 'assets/images/missing.jpg',
    this.category = VeggieCategory.vegetable,
    this.description = 'No description provided.',
    this.accentColor = 0x000000,
    this.seasons = const [],
    this.vitaminAPercentage = 0,
    this.vitaminCPercentage = 0,
    this.servingSize = 'No serving size provided.',
    this.caloriesPerServing = 0,
    this.trivia = const [],
    this.isFavorite = false,
  });

  final int id;

  final String name;

  /// Each veggie has an associated image asset that's used as a background
  /// image and icon.
  final String image;

  final VeggieCategory category;

  /// A short, snappy line.
  final String description;

  /// A color value to use when constructing UI elements to match the image
  /// found at [image].
  final int? accentColor;

  /// Seasons during which a veggie is harvested.
  final List<Season> seasons;

  /// Percentage of the FDA's recommended daily value of vitamin A for someone
  /// with a 2,000 calorie diet.
  final int vitaminAPercentage;

  /// Percentage of the FDA's recommended daily value of vitamin C for someone
  /// with a 2,000 calorie diet.
  final int vitaminCPercentage;

  /// A text description of a single serving (e.g. '1 apple' or '1/2 cup').
  final String servingSize;

  /// Calories per serving (as described in [servingSize]).
  final int caloriesPerServing;

  /// Whether or not the veggie has been saved to the user's garden (i.e. marked
  /// as a favorite).
  final bool isFavorite;

  /// A set of trivia questions and answers related to the veggie.
  final List<Trivia> trivia;

  String? get categoryName => veggieCategoryNames[category];
}
