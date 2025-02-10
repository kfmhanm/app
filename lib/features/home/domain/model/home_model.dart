import 'ads_model.dart';

class HomeModel {
  List<CategoriesModel>? categories;
  List<SlidersModel>? sliders;
  List<AdsModel>? latestAds;
  List<AdsModel>? latest_order;
  List<AdsModel>? ads;
  List<AdsModel>? order;
  String? max_price;

  HomeModel(
      {this.categories,
      this.sliders,
      this.latestAds,
      this.ads,
      this.order,
      this.max_price});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <CategoriesModel>[];
      json['categories'].forEach((v) {
        final CategoriesModel model = CategoriesModel.fromJson(v);
        if (model.showHome == true && model.count_ads != 0) {
          categories!.add(model);
        }
        // categories!.add(new CategoriesModel.fromJson(v));
      });
    }
    json['max_price'] != null
        ? max_price = json['max_price']?.toString()
        : max_price = "0";
    if (json['sliders'] != null) {
      sliders = <SlidersModel>[];
      json['sliders'].forEach((v) {
        sliders!.add(new SlidersModel.fromJson(v));
      });
    }
    if (json['latest_ads'] != null) {
      latestAds = <AdsModel>[];
      json['latest_ads'].forEach((v) {
        latestAds!.add(new AdsModel.fromJson(v));
      });
    }
    if (json['latest_order'] != null) {
      latest_order = <AdsModel>[];
      json['latest_order'].forEach((v) {
        latest_order!.add(new AdsModel.fromJson(v));
      });
    }
    if (json['ads'] != null) {
      ads = <AdsModel>[];
      json['ads'].forEach((v) {
        ads!.add(new AdsModel.fromJson(v));
      });
    }
    if (json['order'] != null) {
      order = <AdsModel>[];
      json['order'].forEach((v) {
        order!.add(new AdsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesModel {
  int? id;
  String? title;
  bool? showHome;
  int? count_ads;

  CategoriesModel({this.id, this.title, this.showHome, this.count_ads});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count_ads = json['count_ads'];
    title = json['title'];
    showHome = json['show_home'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['show_home'] = this.showHome;
    return data;
  }
}

class SlidersModel {
  int? id;
  String? title;
  String? content;
  String? image;

  SlidersModel({this.id, this.title, this.content, this.image});

  SlidersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    return data;
  }
}
