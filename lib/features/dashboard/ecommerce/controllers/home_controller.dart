import 'package:get/get.dart';
import '../../../products/models/product_model.dart';
import '../models/category_model.dart';
import 'categories_controller.dart';
import 'dummy_data.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  List<CategoryModel> getFeaturedCategories() {
    final categoryController=Get.put(CategoryController());
    return categoryController.getFeaturedCategories(8);
  }

  List<ProductModel> getFeaturedProducts() {
    // Get Featured Products from your data source
    return TDummyData.products.where((product) => product.isFeatured ?? false).take(6).toList();
  }

  List<ProductModel> getPopularProducts() {
    // Get Popular Products from your data source
    // Currently, I'm just taking last 4 products
    return TDummyData.products.sublist(TDummyData.products.length - 4).toList();
  }
}
