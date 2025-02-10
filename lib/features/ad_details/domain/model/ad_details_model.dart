import 'dart:io';

import 'package:pride/features/home/domain/model/ads_model.dart';

import '../../../../core/general/models/area_model.dart';
import '../../../create_ad/cubit/create_ad_cubit.dart';
import '../../../home/domain/model/home_model.dart';

class AdDetailsModel {
  int? id;
  String? title;
  String? type;
  String? mainType;
  String? image;
  List<ImagesModel>? images;
  String? createdAt;
  String? price;
  String? priceType;
  AdStatus? status;
  List<CategoryFeatures>? adFeatures;
  List<CommentModel>? comments;
  List<CategoryFeatures>? categoryFeatures;
  String? address;
  String? content;
  bool? isFavorite;
  bool? show_phone;
  bool? is_paying_commission;
  bool? has_chat;
  String? room_id;
  UserAd? user;
  LocationModel? location;
  LocationModel? location_ad;
  LocationModel? location_property;
  AreaModel? area;
  AreaModel? city;
  CategoriesModel? category;
  CategoriesModel? sub_category;

  List<AdsModel>? similarAds;

  AdDetailsModel(
      {this.id,
      this.title,
      this.room_id,
      this.show_phone,
      this.content,
      this.has_chat,
      this.status,
      this.type,
      this.mainType,
      this.image,
      this.images,
      this.createdAt,
      this.price,
      this.priceType,
      this.location,
      this.adFeatures,
      this.comments,
      this.categoryFeatures,
      this.address,
      this.isFavorite,
      this.user,
      this.similarAds,
      this.sub_category,
      this.category,
      this.area,
      this.city,
      this.is_paying_commission,
      this.location_ad,
      this.location_property});

  AdDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    show_phone = json['show_phone'];
    room_id = json['room_id']?.toString();
    has_chat = json['has_chat'];
    type = json['type'];
    status =
        json['status'] != null ? AdStatus.fromString(json['status']) : null;
    mainType = json['main_type'];
    image = json['image'];
    content = json['content'];
    if (json['images'] != null) {
      images = <ImagesModel>[];

      json['images'].forEach((v) {
        images!.add(ImagesModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    price = json['price']?.toString();
    priceType = json['price_type'];
    if (json['ad_features'] != null) {
      adFeatures = <CategoryFeatures>[];
      json['ad_features'].forEach((v) {
        adFeatures!.add(new CategoryFeatures.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <CommentModel>[];
      json['comments'].forEach((v) {
        comments!.add(new CommentModel.fromJson(v));
      });
    }
    if (json['category_features'] != null) {
      categoryFeatures = <CategoryFeatures>[];
      json['category_features'].forEach((v) {
        categoryFeatures!.add(new CategoryFeatures.fromJson(v));
      });
    }
    address = json['address'];
    isFavorite = json['is_favorite'];
    user = json['user'] != null ? new UserAd.fromJson(json['user']) : null;
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : null;

    if (json['similar_ads'] != null) {
      similarAds = <AdsModel>[];
      json['similar_ads'].forEach((v) {
        similarAds!.add(new AdsModel.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = new CategoriesModel.fromJson(json['category']);
    }
    if (json['sub_category'] != null) {
      sub_category = new CategoriesModel.fromJson(json['sub_category']);
    }
    if (json['area'] != null) {
      area = new AreaModel.fromJson(json['area']);
    }
    if (json['city'] != null) {
      city = new AreaModel.fromJson(json['city']);
    }
    is_paying_commission = json['is_paying_commission'];
    location_ad = json['location_ad'] != null
        ? new LocationModel.fromJson(json['location_ad'])
        : null;
    location_property = json['location_property'] != null
        ? new LocationModel.fromJson(json['location_property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['main_type'] = this.mainType;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['price'] = this.price;
    data['price_type'] = this.priceType;
    if (this.adFeatures != null) {
      data['ad_features'] = this.adFeatures!.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    if (this.categoryFeatures != null) {
      data['category_features'] =
          this.categoryFeatures!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['is_favorite'] = this.isFavorite;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }

    if (this.similarAds != null) {
      data['similar_ads'] = this.similarAds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryFeatures {
  int? id;
  String? title;
  String? image;
  String? type;
  bool? isRequired;
  String? value;

  CategoryFeatures(
      {this.id,
      this.title,
      this.image,
      this.type,
      this.isRequired,
      this.value});

  CategoryFeatures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    type = json['type'];
    isRequired = json['is_required'];
    value = json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['type'] = this.type;
    data['is_required'] = this.isRequired;
    data['value'] = this.value;
    return data;
  }
}

class UserAd {
  int? id;
  String? name;
  String? logo;
  String? rate;
  bool? isVerified;
  String? createdAt;
  String? phone;

  UserAd(
      {this.id,
      this.name,
      this.phone,
      this.logo,
      this.rate,
      this.isVerified,
      this.createdAt});

  UserAd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['mobile'];
    name = json['name'];
    logo = json['logo'];
    rate = json['rate']?.toString();
    isVerified = json['is_verified'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['rate'] = this.rate;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class CommentModel {
  final int? id;
  final String? comment;
  final String? createdAt;
  final UserCommentModel? user;

  CommentModel({this.id, this.comment, this.user, this.createdAt});

  // Factory constructor to create a CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      createdAt: json['created_at'],
      comment: json['comment'],
      user:
          json['user'] != null ? UserCommentModel.fromJson(json['user']) : null,
    );
  }

  // Method to convert CommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
    };
  }
}

class UserCommentModel {
  final int? id;
  final String? name;
  final String? image;

  UserCommentModel({this.id, this.name, this.image});

  // Factory constructor to create a UserCommentModel from JSON
  factory UserCommentModel.fromJson(Map<String, dynamic> json) {
    return UserCommentModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  // Method to convert UserCommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class ImagesModel {
  String? url;
  String? id;
  String? file_type;
  String? video;
  String? thumb;
  File? file;

  ImagesModel(
      {this.url, this.id, this.file, this.thumb, this.file_type, this.video});

  ImagesModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    file_type = json['type'];
    thumb = json['thumb'];
    video = json['url'];
    id = json['id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['id'] = this.id;
    return data;
  }
}
