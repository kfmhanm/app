class PaginatedNotificationModel {
  List<NotificationModel>? notification;
  int? page;

  PaginatedNotificationModel({
    this.notification,
    this.page,
  });

  PaginatedNotificationModel.fromMap(Map<String, dynamic> map) {
    if (map['data']['notifications'] != null) {
      notification = <NotificationModel>[];
      for (var e in (map["data"]['notifications'] as List)) {
        notification?.add(
          NotificationModel.fromJson(e),
        );
      }
    }
    page = map['pagination']["lastPage"];
  }
}

class NotificationModel {
  final String? id;
  final NotificationData? data;
  final bool? isRead;
  final String? createdAt;

  NotificationModel({this.id, this.data, this.isRead, this.createdAt});

  // Factory constructor to create a NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      isRead: json['is_read'],
      createdAt: json['created_at'],
    );
  }

  // Method to convert NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data?.toJson(),
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}

class NotificationData {
  final String? title;
  final String? message;
  final String? type;

  NotificationData({this.title, this.message, this.type});

  // Factory constructor to create a NotificationData from JSON
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'],
      message: json['message'],
      type: json['type'],
    );
  }

  // Method to convert NotificationData to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'type': type,
    };
  }
}
