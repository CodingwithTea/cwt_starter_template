import 'package:get/get.dart';

import '../../dashboard/ecommerce/controllers/dummy_data.dart';
import '../../products/models/product_model.dart';
import '../../products/models/product_variation_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  RxDouble totalCartPrice = 0.0.obs;

  // RxMap<String, int> productQuantities = <String, int>{}.obs; // Use to count each product quantity [ID: quantity]

  /// -- Used init to initialize dummy data only
  @override
  void onInit() {
    cartItems.value = TDummyData.cart.items;
    totalCartPrice.value = cartItems
        .map((e) => calculateSingleProductTotal(e.price!, e.quantity))
        .fold(0, (previous, current) => previous + current);
    // Assuming cartItems are already populated
    // cartItems.map((element) => productQuantities.addAll({element.productId: element.quantity})).toList();
    super.onInit();
  }

  void addSingleItemToCart(ProductModel product, ProductVariationModel variation) {
    // If the product is already added then increment the count else add new product
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == product.id && item.variationId == variation.id,
      orElse: () => CartItemModel(
        productId: product.id,
        variationId: variation.id,
        quantity: 0,
        title: product.title,
        image: product.thumbnail,
        price: product.salePrice ?? product.price,
        brandName: product.brand!.name,
      ),
    );

    // If its a new product then add it to the cart.
    if (cartItem.quantity == 0) {
      cartItems.add(cartItem);
    }

    // Increment Cart
    cartItem.quantity += 1;
    // Increment Total Cart Price
    totalCartPrice.value += calculateSingleProductTotal(product.price, 1);
    // Increment Product Quantities
    // productQuantities[product.id] = (productQuantities[product.id] ?? 0) + 1;

    // Must use .refresh() when list or Modal is Observable to change UI
    cartItems.refresh();
  }

  void addMultipleItemsToCart(ProductModel product, ProductVariationModel variation, int quantity) {
    // If the product is already added then increment the count else add new product
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == product.id && item.variationId == variation.id,
      orElse: () => CartItemModel(
        productId: product.id,
        variationId: variation.id,
        quantity: 0,
        title: product.title,
        image: variation.id.isEmpty ? product.thumbnail : variation.image,
        price: variation.id.isEmpty ? product.salePrice ?? product.price : variation.salePrice ?? variation.price,
        brandName: product.brand!.name,
        selectedVariation: variation.id.isNotEmpty ? variation.attributeValues : null,
      ),
    );

    // If its a new product Simply add quantity
    if (cartItem.quantity == 0) {
      // Increment Cart
      cartItem.quantity = quantity;
      cartItems.add(cartItem);
      // Increment Total Cart Price
      totalCartPrice.value += calculateSingleProductTotal(product.price, quantity);
      // Increment Product Quantities
      // productQuantities[product.id] = quantity;
    } else {
      // Check if you need to remove or add items to the cart
      if (cartItem.quantity > quantity) {
        // Subtract
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, quantity);
        // Set the new quantity of productQuantities
        // if (productQuantities.containsKey(product.id)) {
        //   productQuantities[product.id] = (productQuantities[product.id] ?? 0) - quantity;
        // }
      } else {
        // Increment
        totalCartPrice.value += calculateSingleProductTotal(product.price, quantity);
        // if (productQuantities.containsKey(product.id)) {
        //   productQuantities[product.id] = (productQuantities[product.id] ?? 0) + quantity;
        // }
      }

      cartItem.quantity = quantity;
    }

    // Must use .refresh() when list or Modal is Observable to change UI
    cartItems.refresh();
  }

  void removeItemFromCart(CartItemModel cartItem) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        // Remove the item from the cart
        cartItems.remove(cartItem);
        // Remove that product from the Product Quantities.
        // productQuantities.remove(cartItem.productId);
        // Remove the price from the total
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, cartItem.quantity);
        cartItems.refresh();
        Get.back();
      },
      barrierDismissible: true,
    );
  }

  void updateCartItemQuantity(CartItemModel cartItem, int newQuantity) {
    if (newQuantity.isEqual(0)) {
      removeItemFromCart(cartItem);
    } else {
      // If new Quantity is greater means add & if less then [cartItem.quantity] means subtract
      if (cartItem.quantity < newQuantity) {
        // Add
        totalCartPrice.value += calculateSingleProductTotal(cartItem.price!, 1);
        // Increment the quantity in the product Quantities
        // productQuantities[cartItem.productId] = (productQuantities[cartItem.productId] ?? 0) + 1;
      } else if (cartItem.quantity > newQuantity) {
        // Subtract
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, 1);
        // Decrement the quantity from the product Quantities
        // if (productQuantities.containsKey(cartItem.productId)) {
        //   // productQuantities[cartItem.productId] = (productQuantities[cartItem.productId] ?? 0) - 1;
        // }
      }
      cartItem.quantity = newQuantity;
      cartItems.refresh();
    }
  }

  double calculateSingleProductTotal(double productPrice, int quantity) {
    return productPrice * quantity;
  }

  String calculateTotalCartItems() {
    return cartItems
        .map((element) => element.quantity)
        .fold(0, (previousValue, element) => previousValue + element)
        .toString();
  }

  int calculateSingleProductCartEntries(String productId, String variationId) {
    int cartEntries = 0;

    // If variation is not null get variation total
    if (variationId.isEmpty) {
      cartEntries = cartItems
          .where((item) => item.productId == productId)
          .map((e) => e.quantity)
          .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
    } else {
      cartEntries = cartItems
          .where((item) => item.productId == productId && item.variationId == variationId)
          .map((e) => e.quantity)
          .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
    }

    return cartEntries;
  }
}
