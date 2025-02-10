import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_states.dart';
import '../../domain/request/profile_request.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController(
        text: Utils.userModel.name ?? "",
      ),
      emailController = TextEditingController(
        text: Utils.userModel.email ?? "",
      ),
      phoneController = TextEditingController(
        text: Utils.userModel.mobile ?? "",
      );

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  EditProfileRequest model = EditProfileRequest();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = ProfileCubit.get(context);
          return Scaffold(
            appBar: AppbarProfile(
              // image: image,
              tap: (image) {
                setState(() {
                  model.image = image;
                });
              },
            ),
            body: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // 74.ph,
                    TextFormFieldWidget(
                      type: TextInputType.name,
                      hintText: LocaleKeys.settings_name.tr(),
                      password: false,
                      validator: (v) => Utils.valid.defaultValidation(v),
                      controller: nameController,
                    ),
                    12.ph,
                    TextFormFieldWidget(
                      readOnly: true,
                      type: TextInputType.phone,
                      hintText: LocaleKeys.auth_hint_phone.tr(),
                      password: false,
                      validator: (v) => Utils.valid.defaultValidation(v),
                      controller: phoneController,
                    ),
                    12.ph,
                    TextFormFieldWidget(
                      type: TextInputType.emailAddress,
                      hintText: LocaleKeys.email.tr(),
                      password: false,
                      validator: (v) => Utils.valid.emailValidation(v),
                      controller: emailController,
                    ),
                    23.ph,
                    ButtonWidget(
                        title: LocaleKeys.settings_edit_and_save.tr(),
                        withBorder: false,
                        textColor: Colors.white,
                        width: double.infinity,
                        fontSize: 16,
                        fontweight: FontWeight.bold,
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          if (formKey.currentState!.validate()) {
                            model
                              ..name = nameController.text
                              ..email = emailController.text
                              ..phone = phoneController.text;
                            ;
                            // print(model.image);
                            final res = await cubit.editProfile(model);
                            if (res == true) Navigator.pop(context);
                            // setState(() {});
                          }
                        }),
                  ],
                ).scrollable(),
              ),
            ),
          );
        },
      ),
    );
  }
}
