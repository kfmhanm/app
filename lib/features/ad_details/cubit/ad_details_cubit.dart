import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'ad_details_states.dart';

class AdDetailsCubit extends Cubit<AdDetailsStates> {
  AdDetailsCubit() : super(AdDetailsInitial());
  static AdDetailsCubit get(context) => BlocProvider.of(context);

  AdDetailsRepository ad_detailsRepository = locator<AdDetailsRepository>();
  showAd(int id) async {
    emit(AdDetailsLoading());
    final response = await ad_detailsRepository.showAd(id);
    if (response != null) {
      emit(AdDetailsSuccess(response));
    } else {
      emit(AdDetailsError());
    }
  }

  addComment(int id, String comment) async {
    final response = await ad_detailsRepository.addComment(id, comment);
    if (response != null) {
      emit(AddCommentSuccess());
      await showAd(id);
    } else {
      emit(AddCommentError());
    }
  }

  PagingController<int, CommentModel> commentscontroller =
      PagingController<int, CommentModel>(firstPageKey: 1);
  addPageoffersLisnterComment(int id) async {
    commentscontroller.addPageRequestListener((pageKey) {
      getComment(id, pageKey);
    });
  }

  getComment(
    int id,
    int page,
  ) async {
    final res = await ad_detailsRepository.getComments(id, page);
    if (res != null) {
      var isLastPage = res.page == page;

      if (isLastPage) {
        // stop
        commentscontroller.appendLastPage(res.comments ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        commentscontroller.appendPage(res.comments ?? [], nextPageKey);
      }
      // emit(NewState());
    } else {
      commentscontroller.error = 'error';
    }
  }

  getSimilarAd(adId) async {
    emit(SimilarAdLoading());
    final response = await ad_detailsRepository.getAds(adId);
    if (response != null) {
      emit(SimilarAdSuccess(response));
    } else {
      emit(SimilarAdError());
    }
  }

  getAdvistorProfile(int id) async {
    emit(AdvistorProfileLoading());
    final response = await ad_detailsRepository.getAdvistorProfile(id);
    if (response != null) {
      emit(AdvistorProfileSuccess(response));
    } else {
      emit(AdvistorProfileError());
    }
  }

  startChat(String brokerId) async {
    final response = await ad_detailsRepository.startChat(brokerId);
    if (response != null) {
      return response;
    }
  }
}
