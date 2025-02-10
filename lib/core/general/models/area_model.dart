class AreaModel {
  final int? id;
  final String? name;
  final String? area;
  final String? city;

  AreaModel({this.id, this.name, this.area, this.city});

  // Factory constructor to create an AreaModel from JSON
  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      name: json['name'],
      area: json['area'],
      city: json['city'],
    );
  }

  // Method to convert AreaModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'area': area,
    };
  }
}

class PagedAreaModel {
  final List<AreaModel>? areas;
  final int? page;

  PagedAreaModel({
    this.areas,
    this.page,
  });

  factory PagedAreaModel.fromJson(Map<String, dynamic> json) {
    return PagedAreaModel(
      areas: json["data"]["areas"] != null
          ? (json["data"]["areas"] as List)
              .map((i) => AreaModel.fromJson(i))
              .toList()
          : [],
      page: json['pagination']["lastPage"],
    );
  }
  factory PagedAreaModel.fromJsonCities(Map<String, dynamic> json) {
    return PagedAreaModel(
      areas: json["data"]["cities"] != null
          ? (json["data"]["cities"] as List)
              .map((i) => AreaModel.fromJson(i))
              .toList()
          : [],
    );
  }
}
