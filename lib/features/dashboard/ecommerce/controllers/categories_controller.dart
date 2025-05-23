import 'package:get/get.dart';
import '../../../products/models/product_model.dart';
import '../models/category_model.dart';
import 'dummy_data.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  /// -- Load selected category data
  List<CategoryModel> getFeaturedCategories(int take) {
    // Get Featured Brands from your data source
    return TDummyData.categories
        .where((category) => (category.isFeatured ?? false) && category.parentId == null)
        .take(take)
        .toList();
  }

  /// -- Load selected category data
  List<CategoryModel> getSubCategories(String categoryId) {
    // Fetch all categories where ParentId = categoryId;
    final subCategories = TDummyData.categories.where((category) => category.parentId == categoryId).toList();
    return subCategories;
  }

  /// -- Get Sub-Category Products
  List<ProductModel> getSubCategoryProducts(String subCategoryId, int take) {
    // Fetch limited (4) products against each subCategory;
    final products = TDummyData.products.where((product) => product.categoryId == subCategoryId).take(take).toList();
    return products;
  }
}
