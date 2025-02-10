import '../../../create_ad/cubit/create_ad_cubit.dart';

class AdsModel {
  int? id;
  String? title;
  String? image;
  String? createdAt;
  AdStatus? status;
  int? price;
  String? priceType;
  String? amount;
  List<Features>? features;
  String? address;
  bool? isFavorite;
  bool? isSpecial;
  LocationModel? location;

  AdsModel(
      {this.id,
      this.title,
      this.status,
      this.image,
      this.createdAt,
      this.price,
      this.priceType,
      this.amount,
      this.features,
      this.address,
      this.isFavorite,
      this.isSpecial,
      this.location});

  AdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status =
        json['status'] != null ? AdStatus.fromString(json['status']) : null;
    image = json['image'];
    createdAt = json['created_at'];
    price = json['price'];
    priceType = json['price_type'];
    amount = json['amount'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    address = json['address'];
    isFavorite = json['is_favorite'];
    isSpecial = json['is_special'];
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['price'] = this.price;
    data['price_type'] = this.priceType;
    data['amount'] = this.amount;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['is_favorite'] = this.isFavorite;
    data['is_special'] = this.isSpecial;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Features {
  int? id;
  String? title;
  String? unit;
  String? image;
  String? value;

  Features({this.id, this.title, this.unit, this.image, this.value});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    unit = json['unit'];
    image = json['image'];
    value = json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['unit'] = this.unit;
    data['image'] = this.image;
    return data;
  }
}

class LocationModel {
  String? lat;
  String? lng;
  String? address;

  LocationModel({this.lat, this.lng, this.address});

  LocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    return data;
  }
}
