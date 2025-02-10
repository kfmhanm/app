import 'package:pride/features/home/domain/model/ads_model.dart';

import 'ad_details_model.dart';

class PagedCommentModel {
  final List<CommentModel> comments;
  final int page;

  PagedCommentModel({
    required this.comments,
    required this.page,
  });

  factory PagedCommentModel.fromJson(Map<String, dynamic> json) {
    return PagedCommentModel(
      comments: json["data"]['comments'] != null
          ? (json["data"]['comments'] as List)
              .map((i) => CommentModel.fromJson(i))
              .toList()
          : [],
      page: json['pagination']["lastPage"],
    );
  }
}

class PagedAdsModel {
  final List<AdsModel> ads;
  // final int page;

  PagedAdsModel({
    required this.ads,
    // required this.page,
  });

  factory PagedAdsModel.fromJson(Map<String, dynamic> json) {
    return PagedAdsModel(
      ads: json["data"] != null
          ? (json["data"] as List).map((i) => AdsModel.fromJson(i)).toList()
          : [],
      // page: json['pagination']["lastPage"],
    );
  }
}
