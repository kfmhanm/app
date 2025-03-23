import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/back_widget.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../domain/request/static_page_request.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({Key? key}) : super(key: key);

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  ContactUsRequest contactUsRequest = ContactUsRequest();
  // final TextEditingController imageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaticPageCubit(),
      child: BlocConsumer<StaticPageCubit, StaticPageStates>(
          listener: (context, state) {
        if (state is ContactUsSendSuccess) {
          Alerts.snack(text: state.message, state: SnackState.success);
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBar(
            titleAppBar: LocaleKeys.settings_complain.tr(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    20.ph,
                    TextFormFieldWidget(
                      type: TextInputType.name,
                      hintText: LocaleKeys.settings_name.tr(),
                      onSaved: (value) => contactUsRequest.name = value,
                      password: false,
                      validator: (v) => Utils.valid.defaultValidation(v),
                    ),
                    TextFormFieldWidget(
                      type: TextInputType.phone,
                      hintText: LocaleKeys.auth_hint_phone.tr(),
                      onSaved: (value) => contactUsRequest.phone = value,
                      password: false,
                      validator: (v) => Utils.valid.phoneValidation(v),
                    ),
                    TextFormFieldWidget(
                      type: TextInputType.multiline,

                      hintText: LocaleKeys.settings_message_text.tr(),
                      onSaved: (value) => contactUsRequest.message = value,
                      password: false,
                      maxLines: 20,
                      minLines: 5,
                      // contentPadding:   EdgeInsets.symmetric(
                      //     horizontal: 12, vertical: 12),
                      validator: (v) => Utils.valid.defaultValidation(v),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      title: LocaleKeys.settings_send_complain.tr(),
                      // gradient: AppColors.gradientColor,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          await BlocProvider.of<StaticPageCubit>(context)
                              .complain(contactUsRequest: contactUsRequest);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
