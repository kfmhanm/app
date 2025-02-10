import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';

class CreateAdRequest {
  String? title;
  String? category_id;
  String? sub_category_id;
  String? price;
  String? price_type;
  LocationModel? location_ad;
  LocationModel? location_property;
  String? area_id;
  String? city_id;
  String? content;
  String? is_paying_commission;
  String? isAdd;
  String? show_phone;
  String? main_type;
  String? status;
  String? type;
  List<FeaturesCreateAd>? features;
  List<File>? images = [];
  List<ImagesModel>? editImages = [];
  CreateAdRequest({
    this.title,
    this.category_id,
    this.editImages,
    this.sub_category_id,
    this.isAdd,
    this.price,
    this.price_type,
    this.location_ad,
    this.location_property,
    this.area_id,
    this.city_id,
    this.content,
    this.is_paying_commission,
    this.show_phone,
    this.main_type,
    this.status,
    this.type,
    this.features,
    this.images,
  });

  Future<Map<String, dynamic>> toMap() async {
    final result = <String, dynamic>{};

    if (title != null) {
      result.addAll({'title': title});
    }
    if (category_id != null) {
      result.addAll({'category_id': category_id});
    }
    if (sub_category_id != null) {
      result.addAll({'sub_category_id': sub_category_id});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (price_type != null) {
      result.addAll({'price_type': price_type});
    }
    if (location_ad != null) {
      result.addAll({'location_ad': location_ad!.toJson()});
    }
    if (location_property != null) {
      result.addAll({'location_property': location_property!.toJson()});
    }
    if (area_id != null) {
      result.addAll({'area_id': area_id});
    }
    if (city_id != null) {
      result.addAll({'city_id': city_id});
    }
    if (content != null) {
      result.addAll({'content': content});
    }
    // if (is_paying_commission != null) {
    result.addAll({'is_paying_commission': is_paying_commission});
    // }
    if (show_phone != null) {
      result.addAll({'show_phone': show_phone});
    }
    if (main_type != null) {
      result.addAll({'main_type': main_type});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    // if (features != null) {
    // features = [];
    // remove dublicated features by feature_id
    // features!.removeWhere((currentElement) =>
    //     features!.any((e) => e.feature_id == currentElement.feature_id));

    result.addAll({'features': features!.map((x) => x.toMap()).toList()});
    // }
    if (images != null) {
      List<MultipartFile> partsImages = [];
      for (File image in images!) {
        partsImages.add(await MultipartFile.fromFileSync(image.path));
      }
      result.addAll({'images[]': partsImages});
    }

    return result;
  }

  Future<Map<String, dynamic>> toEdit() async {
    List<MultipartFile> partsImages = [];
    for (ImagesModel image in editImages ?? []) {
      if (image.id == null)
        partsImages
            .add(await MultipartFile.fromFileSync(image.file?.path ?? ''));
    }
    return {
      'title': title,
      'category_id': category_id,
      'sub_category_id': sub_category_id,
      'price': price,
      'price_type': price_type,
      'location_ad': location_ad != null ? location_ad!.toJson() : null,
      'location_property':
          location_property != null ? location_property!.toJson() : null,
      'area_id': area_id,
      'city_id': city_id,
      'content': content,
      'is_paying_commission': is_paying_commission,
      'show_phone': show_phone,
      'main_type': main_type,
      'status': status,
      'type': type,
      "_method": "PUT",
      'features': features != null
          ? List<Map<String, dynamic>>.from(features!.map((x) => x.toMap()))
          : null,
      'images[]': partsImages
    };
  }

  factory CreateAdRequest.fromMap(Map<String, dynamic> map) {
    return CreateAdRequest(
      title: map['title'],
      category_id: map['category_id'],
      sub_category_id: map['sub_category_id'],
      price: map['price'],
      price_type: map['price_type'],
      location_ad: map['location_ad'] != null
          ? LocationModel.fromJson(map['location_ad'])
          : null,
      location_property: map['location_property'] != null
          ? LocationModel.fromJson(map['location_property'])
          : null,
      area_id: map['area_id'],
      city_id: map['city_id'],
      content: map['content'],
      is_paying_commission: map['is_paying_commission'],
      show_phone: map['show_phone'],
      main_type: map['main_type'],
      status: map['status'],
      type: map['type'],
      features: map['features'] != null
          ? List<FeaturesCreateAd>.from(
              map['features']?.map((x) => FeaturesCreateAd.fromMap(x)))
          : null,
      // images: map['images'] != null
      //     ? List<File>.from(map['images']?.map((x) => File.fromMap(x)))
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAdRequest.fromJson(String source) =>
      CreateAdRequest.fromMap(json.decode(source));
}

class FeaturesCreateAd {
  String? feature_id;
  String? value;
  FeaturesCreateAd({
    this.feature_id,
    this.value,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (feature_id != null) {
      result.addAll({'feature_id': feature_id});
    }
    if (value != null) {
      result.addAll({'value': value});
    }

    return result;
  }

  factory FeaturesCreateAd.fromMap(Map<String, dynamic> map) {
    return FeaturesCreateAd(
      feature_id: map['feature_id'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeaturesCreateAd.fromJson(String source) =>
      FeaturesCreateAd.fromMap(json.decode(source));
}
