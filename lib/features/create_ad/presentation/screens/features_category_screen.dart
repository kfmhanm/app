import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/general/models/feature_model.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/loadinganderror.dart';
import '../../../ad_details/domain/model/ad_details_model.dart';
import '../../../home/presentation/widgets/widgets.dart';
import '../../cubit/create_ad_cubit.dart';
import '../../cubit/create_ad_states.dart';
import '../../domain/request/create_ad_request.dart';
import 'features_screen.dart';

class FeaturesCategoryScreen extends StatefulWidget {
  const FeaturesCategoryScreen(
      {super.key, this.adDetailsModel, required this.cubit});
  final AdDetailsModel? adDetailsModel;
  final CreateAdCubit cubit;
  @override
  @override
  State<FeaturesCategoryScreen> createState() => _FeaturesCategoryScreenState();
}

class _FeaturesCategoryScreenState extends State<
    FeaturesCategoryScreen> /*  with AutomaticKeepAliveClientMixin */ {
  final formKey = GlobalKey<FormState>();
  CreateAdCubit? cubit;
  List<FeatureModel>? features = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.adDetailsModel != null) {
    //   widget.cubit.featuresCategory = List.generate(
    //       widget.adDetailsModel?.categoryFeatures?.length ?? 0,
    //       (e) => FeatureModel(
    //             value: widget.adDetailsModel?.categoryFeatures?[e].value,
    //             id: widget.adDetailsModel?.categoryFeatures?[e].id,
    //             title: widget.adDetailsModel?.categoryFeatures?[e].title,
    //             isRequired:
    //                 widget.adDetailsModel?.categoryFeatures?[e].isRequired,
    //           ));
    // }
    cubit = CreateAdCubit.get(context)
      ..loadFeathersCategory().then((value) {
        features = value;
        if (cubit?.featuresCategory.isNotEmpty == true) {
          return;
        }
        for (FeatureModel feature in features ?? []) {
          if (feature.isRequired == true) {
            final featureModel = cubit?.featuresCategory.firstWhere(
              (element) => element.id == feature.id,
              orElse: () => FeatureModel(
                id: feature.id,
                title: feature.title,
                isRequired: feature.isRequired,
              ),
            );

            if (!cubit!.featuresCategory.contains(featureModel)) {
              featureModel?.value = feature.value;
              cubit?.featuresCategory.add(featureModel!);
            }
          }
        }
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return BlocConsumer<CreateAdCubit, CreateAdStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBar(
            titleAppBar: LocaleKeys.my_ads_keys_featured_category.tr(),
          ),
          body: LoadingAndError(
            isError: state is LoadFeaturesFailed,
            isLoading: state is LoadFeatures,
            function: () {
              cubit?.loadFeathersCategory();
            },
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomAutoCompleteTextField<FeatureModel>(
                    itemAsString: (s) => s.title ?? "",
                    lable: LocaleKeys.my_ads_keys_featured_category.tr(),
                    showLabel: true,
                    localData: true,
                    function: (s) async {
                      return features?.where((element) {
                            return cubit?.featuresCategory.any(
                                    (element2) => element2.id == element.id) ==
                                false;
                          }).toList() ??
                          [];
                    },
                    onChanged: (FeatureModel? selected) {
                      if (cubit?.featuresCategory
                              .any((element) => element.id == selected?.id) ==
                          false) {
                        cubit?.featuresCategory.add(selected!);
                        setState(() {});
                      }
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          cubit?.featuresCategory.length ?? 0,
                          (index) => FeatureItem(
                            onRemove: () {
                              cubit?.featuresCategory.removeAt(index);
                              setState(() {});
                            },
                            item: cubit?.featuresCategory[index] ??
                                FeatureModel(),
                            cubit: cubit!,
                            onSaved: (value) {
                              cubit?.featuresCategory[index].value = value;
                            },
                          ),
                        ),
                      ),
                    ),

                    //  ListView.builder(
                    //   itemCount: cubit?.featuresCategory.length,
                    //   itemBuilder: (context, index) {
                    //     return FeatureItem(
                    //       cubit: cubit!,
                    //       item: cubit!.featuresCategory[index],
                    //       onSaved: (value) {
                    //         if (value != null && value.isNotEmpty) {
                    //           cubit!.featuresCategory[index].value = value;

                    //         }
                    //       },
                    //     );
                    //   },
                    // ),
                  ),
                  40.ph,
                  ButtonWidget(
                    title: widget.adDetailsModel != null
                        ? LocaleKeys.settings_edit.tr()
                        : LocaleKeys.my_ads_keys_add_ad.tr(),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        // cubit?.request.features = [];

                        // cubit?.request.features?.addAll(
                        //   cubit?.featuresAd
                        //           .map(
                        //             (e) => FeaturesCreateAd(
                        //               feature_id: e.id.toString(),
                        //               value: e.value,
                        //             ),
                        //           )
                        //           .toList() ??
                        //       [],
                        // );
                        // cubit?.request.features
                        //     ?.addAll(cubit?.featuresCategory.map(
                        //           (e) => FeaturesCreateAd(
                        //             feature_id: e.id.toString(),
                        //             value: e.value,
                        //           ),
                        //         ) ??
                        //         []);

                        for (FeatureModel feature
                            in cubit?.featuresCategory ?? []) {
                          cubit?.request.features?.add(FeaturesCreateAd(
                              feature_id: feature.id?.toString(),
                              value: feature.value));
                        }

                        await removeDuplicates(cubit?.request.features ?? []);
                        widget.adDetailsModel != null
                            ? cubit?.update(
                                widget.adDetailsModel?.id ?? 0,
                              )
                            : cubit?.createAd();
                      }
                    },
                  ),
                  40.ph,
                ],
              ).paddingAll(16),
            ),
          ),
        );
      },
    );
  }

  List<FeaturesCreateAd> removeDuplicates(List<FeaturesCreateAd> features) {
    final Set<String?> featureIds = {};
    final List<FeaturesCreateAd> uniqueFeatures = [];

    for (var feature in features) {
      if (featureIds.add(feature.feature_id)) {
        uniqueFeatures.add(feature);
      }
    }

    return uniqueFeatures;
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
