
class CategoryModel {
  String id;
  String name;
  String image;
  String? parentId;
  bool? isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId,
    this.isFeatured,
  });

  static CategoryModel empty() => CategoryModel(id: '', image: '', name: '');
}
