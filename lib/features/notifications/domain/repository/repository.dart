import '../model/notifications_model.dart';
import '../../../../core/data_source/dio_helper.dart';

class NotificationsRepository {
  final DioService dioService;
  NotificationsRepository(this.dioService);
  Future<PaginatedNotificationModel?> getMyNotification(page) async {
    final ApiResponse response =
        await dioService.getData(url: "notifications", query: {
      "page": page,
    });
    if (response.isError == false) {
      return PaginatedNotificationModel.fromMap(response.response?.data);
    } else {
      return null;
    }
  }

  deleteNotification(String id) async {
    final ApiResponse response = await dioService.deleteData(
      url: "notifications/$id",
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }

  deleteAllNotification() async {
    final ApiResponse response = await dioService.deleteData(
      url: "delete_all_notifications",
      loading: true,
    );
    if (response.isError == false) {
      return true;
    } else {
      return false;
    }
  }
}
