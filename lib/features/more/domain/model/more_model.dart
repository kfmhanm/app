class Pages {
  int? id;
  String? title;
  String? image;
  String? content;

  Pages({this.id, this.content, this.title, this.image});

  Pages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class PagesModel {
  List<Pages>? data;

  PagesModel({this.data});

  PagesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Pages>[];
      json['data']["page"].forEach((v) {
        data!.add(Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
