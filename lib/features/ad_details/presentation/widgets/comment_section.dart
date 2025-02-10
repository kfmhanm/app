import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/shared/widgets/profile_image.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../cubit/ad_details_cubit.dart';
import '../../cubit/ad_details_states.dart';
import '../../domain/model/ad_details_model.dart';

class CommentSections extends StatefulWidget {
  CommentSections({
    super.key,
    required this.adDetailsModel,
  });

  final AdDetailsModel adDetailsModel;

  @override
  State<CommentSections> createState() => _CommentSectionsState();
}

class _CommentSectionsState extends State<CommentSections> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdDetailsCubit, AdDetailsStates>(
      listener: (context, state) {
        if (state is AddCommentSuccess) {
          commentController.clear();
        }
      },
      builder: (context, state) {
        final cubit = AdDetailsCubit.get(context);

        return Form(
          key: formKey,
          child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        LocaleKeys.my_ads_keys_comments.tr(),
                        color: context.secondaryColor,
                        weight: FontWeight.w700,
                      ),
                      (widget.adDetailsModel.comments?.isEmpty == true)
                          ? CustomText(
                              LocaleKeys.my_ads_keys_no_comments_yet.tr(),
                              color: LightThemeColors.textHint,
                            )
                          : CustomText(
                              LocaleKeys.home_keys_view_more.tr(),
                              color: LightThemeColors.textHint,
                            ).onTap(() {
                              Navigator.of(context).pushNamed(
                                  Routes.AdCommentsScreen,
                                  arguments: widget.adDetailsModel.id);
                            }),
                    ],
                  ),
                  8.ph,
                  if (widget.adDetailsModel.comments?.isNotEmpty == true)
                    ...List.generate(
                      widget.adDetailsModel.comments?.length ?? 0,
                      (index) {
                        final item = widget.adDetailsModel.comments?[index];
                        return CommentWidget(item: item).paddingVertical(8);
                      },
                    ),
                  12.ph,
                  if (widget.adDetailsModel.user?.id != Utils.userModel.id &&
                      Utils.userModel.id != null)
                    Column(
                      children: [
                        TextFormFieldWidget(
                          minLines: 1,
                          maxLines: 10,
                          type: TextInputType.multiline,
                          hintText: LocaleKeys.my_ads_keys_add_comment.tr(),
                          password: false,
                          prefixIcon: "add_comment".svg(),
                          controller: commentController,
                          validator: (v) => Utils.valid.defaultValidation(v),
                          backgroundColor: Color(0xff12121205).withOpacity(.02),
                          borderColor: Colors.transparent,
                          activeBorderColor: Colors.transparent,
                        ),
                        ButtonWidget(
                          title: LocaleKeys.auth_login.tr(),
                          textColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("send".svg()),
                              8.pw,
                              CustomText(
                                LocaleKeys.send.tr(),
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ],
                          ),
                          width: double.infinity,
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (formKey.currentState!.validate()) {
                              await cubit.addComment(
                                widget.adDetailsModel.id ?? 0,
                                commentController.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                ],
              )),
        );
      },
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.item,
  });

  final CommentModel? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: /*  index % 2 == 0
            ? */
            Colors.white /*   : Colors.grey[200] */,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            ProfileImage(
              image: item?.user?.image,
            ),
            8.pw,
            CustomText(
              item?.user?.name ?? "",
              color: context.secondaryColor,
              weight: FontWeight.w700,
            ),
            // ],
            // ),
          ],
        ),
        8.ph,
        CustomText(
          item?.comment ?? "",
          color: LightThemeColors.textHint,
          // weight: FontWeight.w300,
          fontSize: 16,
          align: TextAlign.start,
        ),
        8.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(
              (item?.createdAt ?? ""),
              color: LightThemeColors.textHint,
              weight: FontWeight.w300,
              fontSize: 14,
            ),
          ],
        ),
      ]),
    );
  }
}
