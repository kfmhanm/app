import '../../../features/home/domain/model/home_model.dart';

class PagedCategoriesModel {
  final List<CategoriesModel>? categories;
  final int? page;

  PagedCategoriesModel({
    this.categories,
    this.page,
  });

  factory PagedCategoriesModel.fromJson(Map<String, dynamic> json) {
    return PagedCategoriesModel(
      categories: json["data"]["categories"] != null
          ? (json["data"]["categories"] as List)
              .map((i) => CategoriesModel.fromJson(i))
              .toList()
          : [],
      page: json['pagination']["lastPage"],
    );
  }
  factory PagedCategoriesModel.fromJsonNotPaged(Map<String, dynamic> json) {
    return PagedCategoriesModel(
      categories: json["data"]["category"] != null
          ? (json["data"]["category"] as List)
              .map((i) => CategoriesModel.fromJson(i))
              .toList()
          : [],
    );
  }
}
