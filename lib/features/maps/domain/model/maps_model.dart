import 'package:pride/features/home/domain/model/ads_model.dart';

class AdsMapModelData {
  List<AdsMapModel>? data;
  List<AdsModel>? allAds;
  AdsMapModelData({this.data, this.allAds});

  AdsMapModelData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AdsMapModel>[];
      json['data'].forEach((v) {
        data!.add(new AdsMapModel.fromJson(v));
      });
    }
    if (data != null) {
      allAds = <AdsModel>[];
      data?.forEach((v) {
        allAds!.addAll(v.ads ?? []);
      });
    }
  }
}

class AdsMapModel {
  List<AdsModel>? ads;
  Details? details;
  AdsMapModel({
    this.ads,
    this.details,
  });

  AdsMapModel.fromJson(Map<String, dynamic> json) {
    if (json['ads'] != null) {
      ads = <AdsModel>[];
      json['ads'].forEach((v) {
        ads!.add(new AdsModel.fromJson(v));
      });
    }
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }
}

class Details {
  int? count;
  LocationModel? location;

  Details({this.count, this.location});

  Details.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}
