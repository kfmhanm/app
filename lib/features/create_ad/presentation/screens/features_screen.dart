
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/general/models/feature_model.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/create_ad/domain/request/create_ad_request.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../ad_details/domain/model/ad_details_model.dart';
import '../../../home/presentation/widgets/widgets.dart';
import '../../cubit/create_ad_cubit.dart';
import '../../cubit/create_ad_states.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key, this.adDetailsModel, required this.cubit});
  final AdDetailsModel? adDetailsModel;
  final CreateAdCubit cubit;
  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState
    extends State<FeaturesScreen> /*    with AutomaticKeepAliveClientMixin */ {
  final formKey = GlobalKey<FormState>();
  CreateAdCubit? cubit;
  List<FeatureModel>? features = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.adDetailsModel != null) {
    //   widget.cubit.featuresAd = List.generate(
    //       widget.adDetailsModel?.adFeatures?.length ?? 0,
    //       (e) => FeatureModel(
    //             value: widget.adDetailsModel?.adFeatures?[e].value,
    //             id: widget.adDetailsModel?.adFeatures?[e].id,
    //             title: widget.adDetailsModel?.adFeatures?[e].title,
    //             isRequired: widget.adDetailsModel?.adFeatures?[e].isRequired,
    //           ));
    // }
    cubit = CreateAdCubit.get(context)
      ..loadFeathers().then((value) {
        features = value;
        if (widget.cubit.featuresAd.isNotEmpty) {
          return;
        }
        for (FeatureModel feature in features ?? []) {
          if (feature.isRequired == true) {
            final featureModel = cubit?.featuresAd.firstWhere(
              (element) => element.id == feature.id,
              orElse: () => FeatureModel(
                id: feature.id,
                title: feature.title,
                isRequired: feature.isRequired,
              ),
            );

            if (!cubit!.featuresAd.contains(featureModel)) {
              featureModel?.value = feature.value;
              cubit?.featuresAd.add(featureModel!);
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
            titleAppBar: LocaleKeys.my_ads_keys_featured_ad.tr(),
          ),
          body: LoadingAndError(
            isError: state is LoadFeaturesFailed,
            isLoading: state is LoadFeatures,
            function: () {
              cubit?.loadFeathers();
            },
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomAutoCompleteTextField<FeatureModel>(
                    showLabel: true,
                    lable: LocaleKeys.my_ads_keys_featured_ad.tr(),
                    itemAsString: (s) => s.title ?? "",
                    localData: true,
                    function: (s) async {
                      return features?.where((element) {
                            return cubit?.featuresAd.any(
                                    (element2) => element2.id == element.id) ==
                                false;
                          }).toList() ??
                          [];
                    },
                    onChanged: (FeatureModel? selected) {
                      if (cubit?.featuresAd
                              .any((element) => element.id == selected?.id) ==
                          false) {
                        cubit?.featuresAd.add(selected!);
                        setState(() {});
                      }
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        // itemCount: cubit?.featuresAd.length,
                        children: List.generate(
                          cubit?.featuresAd.length ?? 0,
                          (index) => FeatureItem(
                            item: cubit?.featuresAd[index] ?? FeatureModel(),
                            cubit: cubit!,
                            onRemove: () {
                              cubit?.featuresAd.removeAt(index);
                              setState(() {});
                            },
                            onSaved: (value) {
                              cubit?.featuresAd[index].value = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  40.ph,
                  ButtonWidget(
                    title: LocaleKeys.auth_next.tr(),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        cubit?.request.features = [];
                        for (FeatureModel feature in cubit?.featuresAd ?? []) {
                          cubit?.request.features?.add(FeaturesCreateAd(
                              feature_id: feature.id?.toString(),
                              value: feature.value));
                        }

                        // log(cubit?.request.features?.length.toString() ?? "");

                        cubit?.tabController.animateTo(2);
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

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class FeatureItem extends StatefulWidget {
  const FeatureItem(
      {super.key,
      required this.item,
      required this.cubit,
      required this.onRemove,
      required this.onSaved});
  final FeatureModel item;
  final CreateAdCubit cubit;
  final void Function(String?)? onSaved;
  final void Function()? onRemove;

  @override
  State<FeatureItem> createState() => _FeatureItemState();
}

class _FeatureItemState extends State<FeatureItem> {
  late TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(
      text: widget.item.value ?? "",
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            controller: controller,
            type: TextInputType.text,
            label: widget.item.title ?? "",
            password: false,
            validator:
                (v) => /* widget.item.isRequired == true
                ?  */
                    Utils.valid.defaultValidation(v) /*  : null */,
            onSaved: (value) {
              widget.onSaved?.call(value);
            },
          ),
        ),
        if (widget.item.isRequired == false) ...[
          8.pw,
          IconButton(
            icon: SvgPicture.asset("delete".svg()),
            onPressed: () {
              widget.onRemove?.call();

              // // widget.item.isRequired == false
              // //     ? () {
              // widget.cubit.featuresAd.remove(widget.item);

              // setState(() {});
              // // }
              // // : Alerts.snack(
              // //     text: "cantdelete".tr(), state: SnackState.failed);
            },
          )
        ]
      ],
    );
  }
}
