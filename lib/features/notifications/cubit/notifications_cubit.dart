import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/utils/Locator.dart';
import '../domain/model/notifications_model.dart';
import '../domain/repository/repository.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitial());
  static NotificationsCubit get(context) => BlocProvider.of(context);

  NotificationsRepository notificationsRepository =
      locator<NotificationsRepository>();

  PagingController<int, NotificationModel> notificationscontroller =
      PagingController<int, NotificationModel>(firstPageKey: 1);
  addPageoffersLisnter() async {
    notificationscontroller.addPageRequestListener((pageKey) {
      getmyNotification(pageKey);
    });
  }

  getmyNotification(int page) async {
    final PaginatedNotificationModel? res =
        await notificationsRepository.getMyNotification(
      page,
    );
    if (res != null) {
      var isLastPage = res.page == page;

      if (isLastPage) {
        // stop
        notificationscontroller.appendLastPage(res.notification ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        notificationscontroller.appendPage(res.notification ?? [], nextPageKey);
      }
      // emit(NewState());
    } else {
      notificationscontroller.error = 'error';
    }
    emit(Refresh());
  }

  deleteNotification(String id) async {
    final res = await notificationsRepository.deleteNotification(id);
    if (res == true) {
      notificationscontroller.refresh();
    } else {
      // emit(ErrorState());
    }
  }

  deleteAllNotification() async {
    final res = await notificationsRepository.deleteAllNotification();
    if (res == true) {
      notificationscontroller.refresh();
    } else {
      // emit(ErrorState());
    }
  }
}
