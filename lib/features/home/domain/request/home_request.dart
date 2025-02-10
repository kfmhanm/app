import 'dart:convert';

class FilterSearch {
  int? category_id;
  int? sub_category_id;
  String? keyword;
  int? area_id;
  int? id;
  int? city_id;
  String? type;
  String? main_type;
  int? room_no;
  num? min_price;
  num? max_price;
  FilterSearch({
    this.category_id,
    this.sub_category_id,
    this.keyword,
    this.area_id,
    this.id,
    this.city_id,
    this.type,
    this.room_no,
    this.main_type,
    this.min_price,
    this.max_price,
  });
// toJson
  Map<String, dynamic> toMap() {
    return {
      'category_id': category_id,
      'sub_category_id': sub_category_id,
      'keyword': keyword,
      'main_type': main_type,
      'area_id': area_id,
      'id': id,
      'city_id': city_id,
      'type': type,
      'room_no': room_no,
      'min_price': min_price,
      'max_price': max_price,
    }..removeWhere((_, v) => v == null || v == '');
  }

  factory FilterSearch.fromMap(Map<String, dynamic> map) {
    return FilterSearch(
      category_id: map['category_id']?.toInt(),
      sub_category_id: map['sub_category_id']?.toInt(),
      keyword: map['keyword'],
      area_id: map['area_id']?.toInt(),
      id: map['id']?.toInt(),
      city_id: map['city_id']?.toInt(),
      type: map['type'],
      room_no: map['room_no']?.toInt(),
      min_price: map['min_price'],
      max_price: map['max_price'],
    );
  }

  factory FilterSearch.fromJson(String source) =>
      FilterSearch.fromMap(json.decode(source));

  FilterSearch copyWith({
    int? category_id,
    int? sub_category_id,
    String? keyword,
    int? area_id,
    int? id,
    int? city_id,
    String? type,
    int? room_no,
    num? min_price,
    num? max_price,
  }) {
    return FilterSearch(
      category_id: category_id ?? this.category_id,
      sub_category_id: sub_category_id ?? this.sub_category_id,
      keyword: keyword ?? this.keyword,
      area_id: area_id ?? this.area_id,
      id: id ?? this.id,
      city_id: city_id ?? this.city_id,
      type: type ?? this.type,
      room_no: room_no ?? this.room_no,
      min_price: min_price ?? this.min_price,
      max_price: max_price ?? this.max_price,
    );
  }
}

class GeneralModel {
  String? name;
  String? id;

  GeneralModel({
    this.name,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    }..removeWhere((_, v) => v == null || v == '');
  }
}
