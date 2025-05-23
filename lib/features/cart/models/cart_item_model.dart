

class CartItemModel {
  int quantity;
  String productId;
  String variationId;
  double? price;
  String? image;
  String? title;
  String? brandName;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.quantity,
    required this.productId,
    required this.variationId,
    this.image,
    this.price,
    this.title,
    this.brandName,
    this.selectedVariation,
  });

  static CartItemModel empty() => CartItemModel(productId: '', variationId: '', quantity: 0);
}
