import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/general/models/feature_model.dart';
import '../../../core/general/general_repo.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import '../domain/request/create_ad_request.dart';
import 'create_ad_states.dart';

class CreateAdCubit extends Cubit<CreateAdStates> {
  CreateAdCubit() : super(CreateAdInitial());
  static CreateAdCubit get(context) => BlocProvider.of(context);

  CreateAdRepository create_adRepository = locator<CreateAdRepository>();
  CreateAdRequest request =
      CreateAdRequest(features: [], show_phone: "0", is_paying_commission: "0");
  List<FeatureModel> featuresCategory = [];
  List<FeatureModel> featuresAd = [];

  late TabController tabController;

  initTabBar(
    TickerProvider vsync,
  ) {
    tabController = TabController(length: 3, vsync: vsync);
  }

  createAd() async {
    final response = await create_adRepository.createAd(request);
    if (response) {
      emit(CreateAdSuccess());
    } else {
      emit(CreateAdFailed());
    }
  }

  update(int id) async {
    final response = await create_adRepository.update(request, id);
    if (response) {
      emit(CreateAdSuccess());
    } else {
      emit(CreateAdFailed());
    }
  }

  deleteImage(String adId, String imageId) async {
    final response = await create_adRepository.deleteImage(adId, imageId);
    if (response) {
      return true;
    }
  }

  // List<FeatureModel>? features = [];
  loadFeathers() async {
    emit(LoadFeatures());
    final res = await locator<GeneralRepo>().getFeaturesAd(
      categoryId: request.sub_category_id,
    );
    if (res != null) {
      // features = res.feature ?? [];
      emit(LoadFeaturesSuccess());
      return res.feature ?? [];
    } else {
      emit(LoadFeaturesFailed());
    }
  }

  loadFeathersCategory() async {
    emit(LoadFeaturesCategory());
    final res = await locator<GeneralRepo>().getFeaturesCategory(
      categoryId: request.sub_category_id,
    );
    if (res != null) {
      emit(LoadFeaturesSuccessCategory());
      return res.feature ?? [];
    } else {
      emit(LoadFeaturesFailedCategory());
    }
  }
}

enum AdStatus {
  active,
  stopped,
  finished;

  String get status {
    switch (this) {
      case AdStatus.active:
        return 'active';
      case AdStatus.stopped:
        return 'stopped';
      case AdStatus.finished:
        return 'finished';
      default:
        return "active";
    }
  }

  String get name {
    switch (this) {
      case AdStatus.active:
        return LocaleKeys.my_ads_keys_active.tr();
      case AdStatus.stopped:
        return LocaleKeys.my_ads_keys_stopped.tr();
      case AdStatus.finished:
        return LocaleKeys.my_ads_keys_finished.tr();
      default:
        return LocaleKeys.my_ads_keys_active.tr();
    }
  }

  Color get color {
    switch (this) {
      case AdStatus.active:
        return Colors.green;
      case AdStatus.stopped:
        return Colors.red;
      case AdStatus.finished:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  static AdStatus fromString(String status) {
    switch (status) {
      case 'active':
        return AdStatus.active;
      case 'stopped':
        return AdStatus.stopped;
      case 'finished':
        return AdStatus.finished;
      default:
        return AdStatus.active;
    }
  }
}

enum MainType {
  normal,
  order;

  String get type {
    switch (this) {
      case MainType.normal:
        return 'normal';
      case MainType.order:
        return 'order';
      default:
        return "normal";
    }
  }

  String get name {
    switch (this) {
      case MainType.normal:
        return LocaleKeys.my_ads_keys_ad;
      case MainType.order:
        return LocaleKeys.my_ads_keys_order;
      default:
        return LocaleKeys.my_ads_keys_ad;
    }
  }

  static MainType fromString(String type) {
    switch (type) {
      case 'normal':
        return MainType.normal;
      case 'order':
        return MainType.order;
      default:
        return MainType.normal;
    }
  }
}

enum Type {
  sell,
  rent;

  String get type {
    switch (this) {
      case Type.sell:
        return 'sell';
      case Type.rent:
        return 'rent';
      default:
        return "sell";
    }
  }

  String get name {
    switch (this) {
      case Type.sell:
        return LocaleKeys.my_ads_keys_sell;
      case Type.rent:
        return LocaleKeys.my_ads_keys_rent;
      default:
        return LocaleKeys.my_ads_keys_sell;
    }
  }

  static Type fromString(String type) {
    switch (type) {
      case 'sell':
        return Type.sell;
      case 'rent':
        return Type.rent;
      default:
        return Type.sell;
    }
  }
}

enum PriceType {
  monthly,
  yearly;

  String get type {
    switch (this) {
      case PriceType.monthly:
        return 'monthly';
      case PriceType.yearly:
        return 'yearly';
      default:
        return "monthly";
    }
  }

  String get name {
    switch (this) {
      case PriceType.monthly:
        return "monthly";
      case PriceType.yearly:
        return "yearly";
      default:
        return "monthly";
    }
  }

  static PriceType fromString(String type) {
    switch (type) {
      case 'monthly':
        return PriceType.monthly;
      case 'yearly':
        return PriceType.yearly;
      default:
        return PriceType.monthly;
    }
  }
}
