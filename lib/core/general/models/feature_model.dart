class PagedFeatureModel {
  List<FeatureModel>? feature;
  int? page;

  PagedFeatureModel({
    this.feature,
    this.page,
  });

  factory PagedFeatureModel.fromJson(Map<String, dynamic> json) {
    return PagedFeatureModel(
      feature: json["data"]["feature"] != null
          ? (json["data"]["feature"] as List)
              .map((i) => FeatureModel.fromJson(i))
              .toList()
          : [],
      page: json['pagination'] != null ? json['pagination']["page"] : 0,
    );
  }
}

class FeatureModel {
  final int? id;
  final String? title;
  final String? image;
  final String? type;
  final bool? isRequired;
  String? value;

  FeatureModel({
    this.id,
    this.title,
    this.image,
    this.type,
    this.isRequired,
    this.value,
  });

  // Factory constructor to create a FeatureModel from JSON
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      type: json['type'],
      isRequired: json['is_required'],
      value: json['value'],
    );
  }

  // Method to convert FeatureModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'type': type,
      'is_required': isRequired,
      'value': value,
    };
  }
}
