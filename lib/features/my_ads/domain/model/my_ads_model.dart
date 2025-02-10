import '../../../home/domain/model/ads_model.dart';

class PaginatedAds {
  List<AdsModel>? myads;
  int? page;

  PaginatedAds({
    this.myads,
    this.page,
  });

  PaginatedAds.fromMap(Map<String, dynamic> map) {
    if (map['data']['ads'] != null) {
      myads = <AdsModel>[];
      for (var e in (map["data"]['ads'] as List)) {
        myads?.add(
          AdsModel.fromJson(e),
        );
      }
    }
    page = map['pagination']["lastPage"];
  }
  PaginatedAds.WithoutPaged(Map<String, dynamic> map) {
    if (map['data']['ads'] != null) {
      myads = <AdsModel>[];
      for (var e in (map["data"]['ads'] as List)) {
        myads?.add(
          AdsModel.fromJson(e),
        );
      }
    }
  }
}
