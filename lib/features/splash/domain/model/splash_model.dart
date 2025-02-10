import 'dart:convert';

class SplashModel {
  List<OnBoardingModel>? onboarding;
  SplashModel({
    this.onboarding,
  });

  factory SplashModel.fromMap(Map<String, dynamic> map) {
    return SplashModel(
      onboarding: map['splashs'] != null
          ? List<OnBoardingModel>.from(
              map['splashs']?.map((x) => OnBoardingModel.fromMap(x)))
          : null,
    );
  }

  factory SplashModel.fromJson(String source) =>
      SplashModel.fromMap(json.decode(source));
}

class OnBoardingModel {
  String? stackUrl;
  String? imageUrl;
  String? title;
  String? subTitle;

  OnBoardingModel({
    this.stackUrl,
    this.imageUrl,
    this.title,
    this.subTitle,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'stackUrl': stackUrl});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'title': title});
    result.addAll({'subTitle': subTitle});

    return result;
  }

  factory OnBoardingModel.fromMap(Map<String, dynamic> map) {
    return OnBoardingModel(
      imageUrl: map['image'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OnBoardingModel.fromJson(String source) =>
      OnBoardingModel.fromMap(json.decode(source));
}
