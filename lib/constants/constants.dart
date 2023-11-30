import 'package:store_app/services/assetsmanager.dart';
import 'package:store_app/models/categories_model.dart';

class constants {
  static List<String> bannerslist = [
    assetsManager.banner1,
    assetsManager.banner2
  ];
  static List<categoriesModel> categorieslist = [
    categoriesModel(
        id: assetsManager.electronics,
        image: assetsManager.electronics,
        name: 'electronics'),
    categoriesModel(
        id: assetsManager.cosmetics,
        image: assetsManager.cosmetics,
        name: 'Accessories'),
    categoriesModel(
        id: assetsManager.mobiles,
        image: assetsManager.mobiles,
        name: 'Phones'),
    categoriesModel(
        id: assetsManager.bookimg, image: assetsManager.bookimg, name: 'books'),
    categoriesModel(
        id: assetsManager.shoes, image: assetsManager.shoes, name: 'shoes'),
    categoriesModel(
        id: assetsManager.watch, image: assetsManager.watch, name: 'watch'),
    categoriesModel(
        id: assetsManager.fashion,
        image: assetsManager.fashion,
        name: 'fashion'),
    categoriesModel(
        id: assetsManager.pc, image: assetsManager.pc, name: 'Laptops'),
  ];
}
