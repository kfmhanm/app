import 'package:pride/features/home/domain/model/ads_model.dart';

class UserModel {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? image;
  bool? notify;
  String? lang;
  String? type;
  bool? isVerified;
  String? createdAt;
  String? date_broker;
  String? avgRate;
  List<AdsModel>? ads;
  String? deep_link_url;
  String? token;

  UserModel({
    this.date_broker,
    this.id,
    this.name,
    this.deep_link_url,
    this.mobile,
    this.createdAt,
    this.isVerified,
    this.avgRate,
    this.email,
    this.image,
    this.notify,
    this.type,
    this.lang,
    this.ads,
    this.token,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      id: user['id'],
      date_broker: user['date_broker'],
      name: user['name'],
      deep_link_url: user['deep_link_url'],
      createdAt: user['created_at'],
      isVerified: user['is_verified'],
      avgRate: user['avg_rate']?.toString(),
      type: user['type'],
      mobile: user['mobile'],
      email: user['email'],
      image: user['image'],
      notify: user['notify'],
      lang: user['lang'],
      ads: user['ads'] != null
          ? List<AdsModel>.from(user['ads'].map((x) => AdsModel.fromJson(x)))
          : null,
      token: json['access_token'],
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      "user": {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'image': image,
        'notify': notify,
        'lang': lang,
      },
      'access_token': token,
    };
  }
}
