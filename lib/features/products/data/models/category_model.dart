import 'package:flutter/material.dart';

class CategoryModel {
  final String value;
  final String name;
  final IconData iconData;

  CategoryModel({
    required this.value,
    required this.name,
    required this.iconData,
  });
}

enum ProductCategory {
  WOMENS_FASHION,
  MENS_FASHION,
  KIDS_FASHION,
  SHOES,
  BAGS,
  JEWELRY,
  WATCHES,

  // Electronics
  SMARTPHONES,
  LAPTOPS,
  TABLETS,
  CAMERAS,
  AUDIO,
  GAMING,
  ACCESSORIES,

  // Home & Living
  HOME_APPLIANCES,
  HOME_DECOR,
  FURNITURE,
  KITCHEN_DINING,

  // Beauty & Health
  BEAUTY,
  PERSONAL_CARE,

  // Sports & Outdoors
  SPORTS_OUTDOORS;

  String get value => name;

  String get displayName {
    switch (this) {
      case ProductCategory.WOMENS_FASHION:
        return "Women's";
      case ProductCategory.MENS_FASHION:
        return "Men's";
      case ProductCategory.KIDS_FASHION:
        return 'Kids';
      case ProductCategory.SHOES:
        return 'Shoes';
      case ProductCategory.BAGS:
        return 'Bags';
      case ProductCategory.JEWELRY:
        return 'Jewelry';
      case ProductCategory.WATCHES:
        return 'Watches';
      case ProductCategory.SMARTPHONES:
        return 'Phones';
      case ProductCategory.LAPTOPS:
        return 'Laptops';
      case ProductCategory.TABLETS:
        return 'Tablets';
      case ProductCategory.CAMERAS:
        return 'Cameras';
      case ProductCategory.AUDIO:
        return 'Audio';
      case ProductCategory.GAMING:
        return 'Gaming';
      case ProductCategory.ACCESSORIES:
        return 'Accessories';
      case ProductCategory.HOME_APPLIANCES:
        return 'Appliances';
      case ProductCategory.HOME_DECOR:
        return 'Home Decor';
      case ProductCategory.FURNITURE:
        return 'Furniture';
      case ProductCategory.KITCHEN_DINING:
        return 'Kitchen';
      case ProductCategory.BEAUTY:
        return 'Beauty';
      case ProductCategory.PERSONAL_CARE:
        return 'Self Care';
      case ProductCategory.SPORTS_OUTDOORS:
        return 'Sports';
    }
  }

  IconData get iconData {
    switch (this) {
      case ProductCategory.WOMENS_FASHION:
        return Icons.woman;
      case ProductCategory.MENS_FASHION:
        return Icons.man;
      case ProductCategory.KIDS_FASHION:
        return Icons.child_care;
      case ProductCategory.SHOES:
        return Icons.sports_volleyball;
      case ProductCategory.BAGS:
        return Icons.shopping_bag;
      case ProductCategory.JEWELRY:
        return Icons.diamond;
      case ProductCategory.WATCHES:
        return Icons.watch;
      case ProductCategory.SMARTPHONES:
        return Icons.smartphone;
      case ProductCategory.LAPTOPS:
        return Icons.laptop_mac;
      case ProductCategory.TABLETS:
        return Icons.tablet_mac;
      case ProductCategory.CAMERAS:
        return Icons.camera_alt;
      case ProductCategory.AUDIO:
        return Icons.headphones;
      case ProductCategory.GAMING:
        return Icons.sports_esports;
      case ProductCategory.ACCESSORIES:
        return Icons.cable;
      case ProductCategory.HOME_APPLIANCES:
        return Icons.kitchen;
      case ProductCategory.HOME_DECOR:
        return Icons.deck;
      case ProductCategory.FURNITURE:
        return Icons.chair;
      case ProductCategory.KITCHEN_DINING:
        return Icons.dining;
      case ProductCategory.BEAUTY:
        return Icons.face;
      case ProductCategory.PERSONAL_CARE:
        return Icons.spa;
      case ProductCategory.SPORTS_OUTDOORS:
        return Icons.sports_basketball;
    }
  }

  CategoryModel toCategoryModel() =>
      CategoryModel(value: name, name: displayName, iconData: iconData);

  static List<CategoryModel> productCategories() =>
      ProductCategory.values.map((c) => c.toCategoryModel()).toList();
}
