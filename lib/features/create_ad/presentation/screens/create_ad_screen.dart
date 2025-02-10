import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/general/general_repo.dart';
import 'package:pride/core/services/media/my_media.dart';
import 'package:pride/core/utils/Locator.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';
import 'package:pride/features/home/domain/model/home_model.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/button_widget.dart';
import 'package:pride/shared/widgets/customtext.dart';
import '../../../../core/general/models/area_model.dart';
import '../../../../core/general/models/feature_model.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/location_picker_screen.dart';
import '../../../../shared/widgets/paged_autocomplete.dart';
import '../../../../shared/widgets/shimer_loading_items.dart';
import '../../../ad_details/domain/model/ad_details_model.dart';
import '../../cubit/create_ad_cubit.dart';
import '../../cubit/create_ad_states.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({Key? key, this.adDetailsModel, required this.cubit})
      : super(key: key);
  final AdDetailsModel? adDetailsModel;
  final CreateAdCubit cubit;
  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController categoryController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController adLocationController = TextEditingController();
  TextEditingController propertyLocationController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  // TextEditingController priceTypeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController mainTypeController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    adLocationController.dispose();
    contentController.dispose();
    propertyLocationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.adDetailsModel != null) {
      nameController.text = widget.adDetailsModel?.title ?? '';
      // priceTypeController.text = widget.adDetailsModel?.priceType?.tr() ?? '';
      priceController.text = widget.adDetailsModel?.price ?? '';
      adLocationController.text =
          widget.adDetailsModel?.location_ad?.address ?? '';
      propertyLocationController.text =
          widget.adDetailsModel?.location_property?.address ?? '';
      statusController.text = widget.adDetailsModel?.status?.name ?? '';
      areaController.text = widget.adDetailsModel?.area?.area ?? '';
      cityController.text = widget.adDetailsModel?.city?.city ?? '';

      contentController.text = widget.adDetailsModel?.content ?? '';
      categoryController.text = widget.adDetailsModel?.category?.title ?? '';
      subCategoryController.text =
          widget.adDetailsModel?.sub_category?.title ?? '';

      mainTypeController.text = widget.adDetailsModel?.mainType?.tr() ?? '';
      typeController.text = widget.adDetailsModel?.type?.tr() ?? '';
      //////////////////
      ///
      widget.cubit.request.editImages =
          List.from(widget.adDetailsModel?.images ?? []);
      widget.cubit.request.location_ad = widget.adDetailsModel?.location;
      widget.cubit.request.show_phone =
          widget.adDetailsModel?.show_phone == true ? "1" : "0";
      widget.cubit.request.category_id =
          widget.adDetailsModel?.category?.id.toString() ?? '';
      widget.cubit.request.sub_category_id =
          widget.adDetailsModel?.sub_category?.id?.toString() ?? '';
      widget.cubit.request.location_ad = widget.adDetailsModel?.location_ad;
      widget.cubit.featuresAd = widget.adDetailsModel?.adFeatures
              ?.map(
                (e) => FeatureModel(
                  value: e.value,
                  id: e.id,
                  title: e.title,
                  isRequired: e.isRequired,
                ),
              )
              .toList() ??
          [];
      widget.cubit.featuresCategory = widget.adDetailsModel?.categoryFeatures
              ?.map(
                (e) => FeatureModel(
                  value: e.value,
                  id: e.id,
                  title: e.title,
                  isRequired: e.isRequired,
                ),
              )
              .toList() ??
          [];

      widget.cubit.request.location_property =
          widget.adDetailsModel?.location_property;

      ///
      widget.cubit.request.area_id =
          widget.adDetailsModel?.area?.id.toString() ?? '';
      widget.cubit.request.city_id =
          widget.adDetailsModel?.city?.id.toString() ?? '';

      widget.cubit.request.is_paying_commission =
          widget.adDetailsModel?.is_paying_commission == true ? "1" : "0";
      widget.cubit.request.main_type = widget.adDetailsModel?.mainType ?? '';
      widget.cubit.request.status = widget.adDetailsModel?.status?.status ?? '';
      widget.cubit.request.type = widget.adDetailsModel?.type ?? '';
      // widget.cubit.request.is_paying_commission =
      //     widget.adDetailsModel?.is_paying_commission == true ? "1" : "0";
      // cubit.request.features = widget.adDetailsModel?.adFeatures ?? [];
      // cubit.request.images = widget.adDetailsModel?.images ?? [];
      // print(widget.cubit.request.toEdit());
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<CreateAdCubit, CreateAdStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = widget.cubit;
        return Scaffold(
          appBar: DefaultAppBar(
            titleAppBar: LocaleKeys.my_ads_keys_add_ad.tr(),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormFieldWidget(
                    controller: nameController,
                    type: TextInputType.name,
                    hintText: LocaleKeys.my_ads_keys_set_ad_title.tr(),
                    password: false,
                    validator: (v) => Utils.valid.defaultValidation(v),
                    onSaved: (value) => cubit.request.title = value,
                  ),
                  PagedCustomAutoCompleteTextField<CategoriesModel>(
                    hint: LocaleKeys.my_ads_keys_set_category.tr(),
                    itemAsString: (p0) => p0.title ?? '',
                    controller: categoryController,
                    showSufix: true,
                    onPage: (page, search) async =>
                        (await locator<GeneralRepo>().getCategories(
                          page: page,
                        ))
                            ?.categories ??
                        [],
                    onChanged: (value) {
                      cubit.request.category_id = value.id.toString();
                      cubit.request.sub_category_id = null;
                      subCategoryController.clear();
                      widget.cubit.featuresCategory.clear();
                      widget.cubit.featuresCategory = [];
                      widget.cubit.featuresAd.clear();
                      widget.cubit.featuresAd = [];
                      widget.cubit.request.features?.clear();
                      setState(() {});
                    },
                    validator: (v) => Utils.valid.defaultValidation(v),
                    itemBuilder: (context, item) {
                      return ListTile(
                        title: CustomText(item.title!),
                      );
                    },
                  ),
                  CustomAutoCompleteTextField<CategoriesModel>(
                    hint: LocaleKeys.my_ads_keys_set_sub_category.tr(),
                    enabled: cubit.request.category_id != null,
                    itemAsString: (p0) => p0.title ?? '',
                    controller: subCategoryController,
                    showSufix: true,
                    function: (search) async =>
                        (await locator<GeneralRepo>().getSubCategories(
                          id: cubit.request.category_id,
                        ))
                            ?.categories ??
                        [],
                    onChanged: (value) {
                      cubit.request.sub_category_id = value.id.toString();
                      widget.cubit.featuresCategory.clear();
                      widget.cubit.featuresCategory = [];
                      widget.cubit.featuresAd.clear();
                      widget.cubit.featuresAd = [];
                      widget.cubit.request.features = [];
                    },
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  TextFormFieldWidget(
                    type: TextInputType.streetAddress,
                    hintText: LocaleKeys.my_ads_keys_set_ad_title_again.tr(),
                    onTap: () async {
                      final List? res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationPickerScreen(),
                        ),
                      );
                      if (res != null) {
                        final Placemark placemark = res[1].first;
                        cubit.request.location_ad = LocationModel(
                          lat: res[0].latitude.toString(),
                          lng: res[0].longitude.toString(),
                          address:
                              "${placemark.country ?? ''} ${placemark.street ?? ''}",
                        );

                        adLocationController.text =
                            cubit.request.location_ad?.address ?? '';
                      }
                    },
                    password: false,
                    validator: (v) => Utils.valid.defaultValidation(v),
                    controller: adLocationController,
                    suffixIcon: CircleAvatar(
                      backgroundColor: context.primaryColor.withOpacity(.18),
                      child: SvgPicture.asset(
                        "location".svg(),
                      ),
                    ).paddingAll(8),
                  ),
                  TextFormFieldWidget(
                    type: TextInputType.streetAddress,
                    hintText: LocaleKeys.my_ads_keys_set_property_title.tr(),
                    onTap: () async {
                      final List? res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationPickerScreen(),
                        ),
                      );
                      if (res != null) {
                        final Placemark placemark = res[1].first;
                        cubit.request.location_property = LocationModel(
                          lat: res[0].latitude.toString(),
                          lng: res[0].longitude.toString(),
                          address:
                              "${placemark.country ?? ''} ${placemark.street ?? ''}",
                        );

                        propertyLocationController.text =
                            cubit.request.location_property?.address ?? '';
                      }
                    },
                    password: false,
                    suffixIcon: CircleAvatar(
                      backgroundColor: context.primaryColor.withOpacity(.18),
                      child: SvgPicture.asset(
                        "location".svg(),
                      ),
                    ).paddingAll(8),
                    validator: (v) => Utils.valid.defaultValidation(v),
                    controller: propertyLocationController,
                  ),
                  TextFormFieldWidget(
                    controller: priceController,
                    type: TextInputType.number,
                    hintText: LocaleKeys.my_ads_keys_set_price.tr(),
                    password: false,
                    onSaved: (value) => cubit.request.price = value,
                  ),
                  CustomAutoCompleteTextField<Type>(
                    hint: LocaleKeys.my_ads_keys_type.tr(),
                    function: (search) => Type.values,
                    controller: typeController,
                    showSufix: true,
                    localData: true,
                    onChanged: (value) {
                      cubit.request.type = value.type;
                      if (cubit.request.type == "sell") {
                        cubit.request.price_type = "";
                      }
                      setState(() {});
                    },
                    itemAsString: (p0) => p0.name.tr(),
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  Visibility(
                    visible: cubit.request.type == "rent" ||
                        cubit.request.type == null,
                    child: CustomAutoCompleteTextField<PriceType>(
                      showSufix: true,
                      localData: true,

                      itemAsString: (p0) => p0.name.tr(),
                      function: (search) => PriceType.values,
                      initialValue:
                          widget.adDetailsModel?.priceType?.tr() ?? '',
                      // controller: priceTypeController,
                      hint: LocaleKeys.my_ads_keys_price_type.tr(),
                      onChanged: (value) =>
                          cubit.request.price_type = value.type,
                      validator: (v) => cubit.request.type == "rent"
                          ? Utils.valid.defaultValidation(v)
                          : null,
                    ),
                  ),
                  PagedCustomAutoCompleteTextField<AreaModel>(
                    hint: LocaleKeys.my_ads_keys_select_Area.tr(),
                    itemAsString: (p0) => p0.name ?? '',
                    controller: areaController,
                    showSufix: true,
                    onPage: (page, search) async =>
                        (await locator<GeneralRepo>().getArea(
                          page: page,
                        ))
                            ?.areas ??
                        [],
                    onChanged: (value) {
                      cubit.request.area_id = value.id.toString();
                      cityController.clear();
                      cubit.request.city_id = null;
                      setState(() {});
                    },
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  CustomAutoCompleteTextField<AreaModel>(
                    enabled: cubit.request.area_id != null,
                    hint: LocaleKeys.my_ads_keys_select_city.tr(),
                    itemAsString: (p0) => p0.name ?? '',
                    controller: cityController,
                    showSufix: true,
                    function: (search) async =>
                        (await locator<GeneralRepo>().getCities(
                          id: cubit.request.area_id,
                        ))
                            ?.areas ??
                        [],
                    onChanged: (value) {
                      cubit.request.city_id = value.id.toString();
                    },
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  CustomAutoCompleteTextField<AdStatus>(
                    hint: LocaleKeys.my_ads_keys_ad_status.tr(),
                    function: (search) => AdStatus.values,
                    controller: statusController,
                    showSufix: true,
                    localData: true,
                    onChanged: (value) {
                      cubit.request.status = value.status;
                    },
                    itemAsString: (p0) => p0.name.tr(),
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  CustomAutoCompleteTextField<MainType>(
                    hint: LocaleKeys.my_ads_keys_main_type.tr(),
                    function: (search) => MainType.values,
                    showSufix: true,
                    controller: mainTypeController,
                    localData: true,
                    onChanged: (value) {
                      cubit.request.main_type = value.type;
                    },
                    itemAsString: (p0) => p0.name.tr(),
                    validator: (v) => Utils.valid.defaultValidation(v),
                  ),
                  TextFormFieldWidget(
                    type: TextInputType.multiline,
                    hintText: LocaleKeys.my_ads_keys_ad_text.tr(),
                    password: false,
                    minLines: 4,
                    maxLines: 10,
                    controller: contentController,
                    validator: (v) => Utils.valid.defaultValidation(v),
                    onSaved: (value) => cubit.request.content = value,
                  ),
                  ToggleSection(
                    inital: widget.adDetailsModel?.show_phone == true,
                    title: LocaleKeys.my_ads_keys_show_phone_number.tr(),
                    value: (value) {
                      cubit.request.show_phone = value;
                    },
                  ),
                  ToggleSection(
                    inital: widget.adDetailsModel?.is_paying_commission == true,
                    title: LocaleKeys.my_ads_keys_commit_to_pay_commission.tr(),
                    value: (value) {
                      cubit.request.is_paying_commission = value;
                    },
                  ),
                  12.ph,
                  SizedBox(
                    height: 90,
                    child: widget.adDetailsModel != null
                        ? Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "add_media".svg(),
                                  ),
                                  4.ph,
                                  CustomText(
                                    LocaleKeys
                                        .my_ads_keys_attach_photos_or_videos
                                        .tr(),
                                    align: TextAlign.center,
                                    fontSize: 12,
                                  ),
                                ],
                              )
                                  .setDashedContainerToView(
                                      color:
                                          context.primaryColor.withOpacity(.18),
                                      borderRadius: BorderRadius.circular(10),
                                      borderColor: context.primaryColor,
                                      width: 80,
                                      height: 90)
                                  .onTap(() async {
                                final List<File>? res =
                                    await locator<MyMedia>().pickFiles();
                                if (res != null) {
                                  if (cubit.request.editImages == null) {
                                    cubit.request.editImages = [];
                                  }
                                  cubit.request.editImages
                                      ?.addAll(res.map((e) => ImagesModel(
                                            id: null,
                                            file: e,
                                            file_type: (e.path
                                                        .toLowerCase()
                                                        .endsWith('.mp4') ||
                                                    e.path
                                                        .toLowerCase()
                                                        .endsWith('.mov'))
                                                ? "video"
                                                : "image",
                                          )));
                                  setState(() {});
                                  // print(cubit.request.images);
                                }
                              }),
                              12.pw,
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      cubit.request.editImages?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ((cubit.request.editImages?[index]
                                                        .file?.path
                                                        .toLowerCase()
                                                        .endsWith('.mp4') ==
                                                    true ||
                                                cubit.request.editImages?[index]
                                                        .file?.path
                                                        .toLowerCase()
                                                        .endsWith('.mov') ==
                                                    true) &&
                                            cubit.request.editImages?[index]
                                                    .url ==
                                                null &&
                                            cubit.request.editImages?[index]
                                                    .id ==
                                                null)
                                        ? FutureBuilder<Uint8List>(
                                            future: Utils.myMedia
                                                .generateVideoThumbnail(
                                                    file: cubit
                                                        .request
                                                        .editImages?[index]
                                                        .file),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                return ClipRRect(
                                                  // borderRadius:
                                                  //     BorderRadius.circular(
                                                  //         16),
                                                  child: LoadingImage(
                                                    h: 80,
                                                    w: 80,
                                                  ),
                                                );
                                              }
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  // borderRadius:
                                                  //     BorderRadius.circular(
                                                  //         10),
                                                  image: DecorationImage(
                                                    image: Image(
                                                      image: MemoryImage(
                                                        snapshot.data!,
                                                      ),
                                                    ).image,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    cubit.request.editImages
                                                        ?.removeAt(index);
                                                    setState(() {});
                                                  },
                                                ).paddingAll(4),
                                              );
                                            })
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: cubit
                                                            .request
                                                            .editImages?[index]
                                                            .url !=
                                                        null
                                                    ? (cubit.request.editImages?[index].url
                                                                    ?.toLowerCase()
                                                                    .endsWith(
                                                                        '.mp4') ==
                                                                true ||
                                                            cubit
                                                                    .request
                                                                    .editImages?[
                                                                        index]
                                                                    .url
                                                                    ?.toLowerCase()
                                                                    .endsWith(
                                                                        '.mov') ==
                                                                true)
                                                        ? Image(image: NetworkImage(cubit.request.editImages?[index].thumb ?? ""))
                                                            .image
                                                        : Image(
                                                                image: NetworkImage(cubit
                                                                        .request
                                                                        .editImages?[index]
                                                                        .url ??
                                                                    ""))
                                                            .image
                                                    : Image(
                                                        image: FileImage(cubit
                                                                .request
                                                                .editImages?[
                                                                    index]
                                                                .file ??
                                                            File("")),
                                                      ).image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                if (cubit
                                                        .request
                                                        .editImages?[index]
                                                        .id !=
                                                    null) {
                                                  final res =
                                                      await cubit.deleteImage(
                                                          widget.adDetailsModel!
                                                              .id
                                                              .toString(),
                                                          widget.adDetailsModel!
                                                              .images![index].id
                                                              .toString());
                                                  if (res == true) {
                                                    cubit.request.editImages
                                                        ?.removeAt(index);
                                                    setState(() {});
                                                  }
                                                } else {
                                                  cubit.request.editImages
                                                      ?.removeAt(index);
                                                  setState(() {});
                                                }
                                              },
                                            ).paddingAll(4));
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "add_media".svg(),
                                  ),
                                  4.ph,
                                  CustomText(
                                    LocaleKeys
                                        .my_ads_keys_attach_photos_or_videos
                                        .tr(),
                                    align: TextAlign.center,
                                    fontSize: 12,
                                  ),
                                ],
                              )
                                  .setDashedContainerToView(
                                      color:
                                          context.primaryColor.withOpacity(.18),
                                      borderRadius: BorderRadius.circular(10),
                                      borderColor: context.primaryColor,
                                      width: 80,
                                      height: 90)
                                  .onTap(() async {
                                final List<File>? res =
                                    await locator<MyMedia>().pickFiles();
                                if (res != null) {
                                  if (cubit.request.images == null) {
                                    cubit.request.images = [];
                                  }
                                  cubit.request.images?.addAll(res);
                                  setState(() {});
                                  // print(cubit.request.images);
                                }
                              }),
                              12.pw,
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cubit.request.images?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return Builder(builder: (context) {
                                      return (cubit.request.images![index].path
                                                  .toLowerCase()
                                                  .endsWith('.mp4') ||
                                              cubit.request.images![index].path
                                                  .toLowerCase()
                                                  .endsWith('.mov'))
                                          ? FutureBuilder<Uint8List>(
                                              future: Utils.myMedia
                                                  .generateVideoThumbnail(
                                                      file: cubit.request
                                                          .images?[index]),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData ||
                                                    snapshot.connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                  return ClipRRect(
                                                    // borderRadius:
                                                    //     BorderRadius.circular(
                                                    //         16),
                                                    child: LoadingImage(
                                                      h: 80,
                                                      w: 80,
                                                    ),
                                                  );
                                                }
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // borderRadius:
                                                    //     BorderRadius.circular(
                                                    //         10),
                                                    image: DecorationImage(
                                                      image: Image(
                                                        image: MemoryImage(
                                                          snapshot.data!,
                                                        ),
                                                      ).image,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      cubit.request.images
                                                          ?.removeAt(index);
                                                      setState(() {});
                                                    },
                                                  ).paddingAll(4),
                                                );
                                              })
                                          : Container(
                                              width: 80,
                                              height: 80,
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: Image(
                                                    image: FileImage(cubit
                                                            .request
                                                            .images?[index] ??
                                                        File("")),
                                                  ).image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  cubit.request.images
                                                      ?.removeAt(index);
                                                  setState(() {});
                                                },
                                              ).paddingAll(4));
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                  ),
                  40.ph,
                  ButtonWidget(
                    title: LocaleKeys.auth_next.tr(),
                    onTap: () async {
                      // print()
                      // cubit.tabController.animateTo(1);
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (widget.adDetailsModel == null) {
                          if (cubit.request.images == null ||
                              cubit.request.images?.isEmpty == true) {
                            // print("object");
                            Alerts.snack(
                              text: LocaleKeys
                                  .my_ads_keys_attach_photos_or_videos
                                  .tr(),
                              state: SnackState.failed,
                            );
                            return;
                          }
                        } else if (widget.adDetailsModel != null &&
                            (cubit.request.editImages == null ||
                                cubit.request.editImages?.isEmpty == true)) {
                          // print("object444");
                          Alerts.snack(
                            text: LocaleKeys.my_ads_keys_attach_photos_or_videos
                                .tr(),
                            state: SnackState.failed,
                          );
                          return;
                        }
                        if (cubit.request.is_paying_commission != "1") {
                          Alerts.snack(
                            text: "agree_commision".tr(),
                            state: SnackState.failed,
                          );
                          return;
                        }
                        cubit.tabController.animateTo(1);
                      }
                      // print(cubit.request.toEdit());
                    },
                  )
                ],
              ).paddingAll(16),
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ToggleSection extends StatefulWidget {
  const ToggleSection({
    super.key,
    required this.title,
    this.title1,
    this.title2,
    required this.value,
    this.inital,
  });
  final String title;
  final String? title1;
  final String? title2;
  final Function(String value) value;
  final bool? inital;

  @override
  State<ToggleSection> createState() => _ToggleSectionState();
}

class _ToggleSectionState extends State<ToggleSection> {
  bool value = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.inital ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(widget.title),
        12.pw,
        Radio.adaptive(
          groupValue: value,
          value: true,
          onChanged: (value) {
            widget.value.call("1");
            this.value = true;
            setState(() {});
          },
        ),
        CustomText(widget.title1 ?? LocaleKeys.yes.tr(), fontSize: 16),
        12.pw,
        Radio.adaptive(
          groupValue: value,
          value: false,
          onChanged: (value) {
            // print(value);
            widget.value.call("0");
            this.value = false;

            setState(() {});
          },
        ),
        CustomText(
          widget.title2 ?? LocaleKeys.no.tr(),
          fontSize: 16,
        ),
      ],
    );
  }
}
