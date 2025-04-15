import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/general/nafath/nafath_cubit.dart';
import 'package:pride/core/theme/light_theme.dart';

import '../../../../../core/Router/Router.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customtext.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';

import '../../../domain/request/auth_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();
  AuthRequest authRequest = AuthRequest();
  String? nationalId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeDependencies();
    //  Utils.nafathtoken = await Utils.dataManager.getData('nafathtoken');
    // log(Utils.nafathtoken.toString(), name: "ss");
    // log(state.name);
    if (state == AppLifecycleState.resumed) {
      context.read<NafathCubit>().getNafathtoken();

      /*
      if (Utils.nafathtoken != null) {
        context
            .read<NafathCubit>()
            .loginRequestFromNotification(Utils.nafathtoken!);
      }*/
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocListener<NafathCubit, NafathState>(
        listener: (context, state) {
          if (state is NafathRecieveRandomNumberfail) {
            Alerts.snack(
                text: "يجب ادخل رقم القومي صحيح", state: SnackState.failed);
          }
          if (state is NafathRecieveRandomNumberSuccessful) {
            Alerts.dialog(
              context,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter the following number in Nafath:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context
                          .read<NafathCubit>()
                          .randomNumber
                          .toString(), // Display the random number
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ButtonWidget(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Utils.redirectToNafath();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoginSuccessState ||
                state is ActivateCodeSuccessState) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.LayoutScreen, (route) => false);
            }
            if (state is LoginNeedActivateState) {
              Navigator.pushNamed(
                context,
                Routes.OtpScreen,
                arguments: OtpArguments(
                  sendTo: state.phone ?? '',
                  onSubmit: (s) async {
                    authRequest.code = s;
                    final res = await AuthCubit.get(context).activate(
                      registerRequestModel: authRequest,
                    );
                    if (res == true) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.LayoutScreen,
                        (route) => false,
                      );
                    }
                  },
                  onReSend: () async {
                    await AuthCubit.get(context).resendCode(
                      authRequest.phone ?? '',
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = AuthCubit.get(context);

            if (Utils.ios==true)  {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leadingWidth: 80,
                  title: CustomText(
                    LocaleKeys.auth_login.tr(),
                    fontSize: 18,
                    color: context.secondaryColor,
                    weight: FontWeight.w700,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            LocaleKeys.auth_description_login.tr(),
                            fontSize: 14,
                            weight: FontWeight.w300,
                          ),
                          40.ph,
                          Image.asset(
                            "logo".png("icons"),
                            scale: 3,
                          ),
                          50.ph,
                          TextFormFieldWidget(
                            hintText: "enterUserData".tr(),
                            password: false,
                            type: TextInputType.number,
                            onChanged: (value) {
                              nationalId = value;
                            },
                          ),
                          20.ph,
                          ButtonWidget(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  LocaleKeys.auth_login_by_gate.tr(),
                                  // "تسجيل الدخول عن طريق بوابة النفاذ الوطنى الموحد",
                                  fontSize: 16,
                                  color: context.primaryColor,
                                  weight: FontWeight.w700,
                                ),
                                4.pw,
                                Image.asset("other_login".png("icons")),
                              ],
                            ),
                            withBorder: true,
                            buttonColor: Colors.white,
                            width: double.infinity,
                            // padding: const EdgeInsets.symmetric(horizontal: 15),
                            onTap: () async {
                              bool notificationAllowed =
                                  await Utils.requestNotificationPermission();
                              if (!notificationAllowed) {
                                Alerts.snack(
                                    text: "يجب تفعيل الاشعارات اولا",
                                    state: SnackState.failed);
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              if (nationalId != null) {
                                //   Navigator.pop(context);

                                context
                                    .read<NafathCubit>()
                                    .loginWithNafat(nationalId!);
                              } else {
                                Alerts.snack(
                                    text: "يجب ادخل رقم القومي",
                                    state: SnackState.failed);
                              }
                            },
                          ),
                          40.ph,
                          ButtonWidget(
                            title: "visitor".tr(),
                            withBorder: true,
                            buttonColor: Colors.white,
                            textColor: context.primaryColor,
                            borderColor: context.primaryColor,
                            width: double.infinity,

                            // padding: const EdgeInsets.symmetric(horizontal: 15),
                            onTap: () async {
                              print(Utils.token);
                              Navigator.pushNamed(
                                context,
                                Routes.LayoutScreen,
                              );
                            },
                          ),
                          20.ph,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leadingWidth: 80,
                title: CustomText(
                  LocaleKeys.auth_login.tr(),
                  fontSize: 18,
                  color: context.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          LocaleKeys.auth_description_login.tr(),
                          fontSize: 14,
                          weight: FontWeight.w300,
                        ),
                        40.ph,
                        Image.asset(
                          "logo".png("icons"),
                          scale: 3,
                        ),
                        50.ph,
                        TextFormFieldWidget(
                          type: TextInputType.phone,
                          hintText: LocaleKeys.auth_hint_phone.tr(),
                          password: false,
                          validator: (v) => Utils.valid.phoneValidation(v),
                          onSaved: (value) => authRequest.phone = value,
                        ),
                        12.ph,
                        TextFormFieldWidget(
                          type: TextInputType.visiblePassword,
                          hintText: LocaleKeys.password.tr(),
                          password: true,
                          // validator: (v) => Utils.valid.passwordValidation(v),
                          onSaved: (value) => authRequest.password = value,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButtonWidget(
                                text: LocaleKeys.auth_forgot_pass.tr(),
                                size: 14,
                                color: context.secondaryColor,
                                // weight: w300,
                                function: () {
                                  Navigator.pushNamed(
                                      context, Routes.forget_passScreen);
                                }),
                          ],
                        ),
                        30.ph,
                        ButtonWidget(
                          title: LocaleKeys.auth_login.tr(),
                          textColor: Colors.white,
                          width: double.infinity,
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              await cubit.login(loginRequestModel: authRequest);
                            }
                          },
                        ),
                        20.ph,
                        ButtonWidget(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                LocaleKeys.auth_login_by_gate.tr(),
                                // "تسجيل الدخول عن طريق بوابة النفاذ الوطنى الموحد",
                                fontSize: 16,
                                color: context.primaryColor,
                                weight: FontWeight.w700,
                              ),
                              4.pw,
                              Image.asset("other_login".png("icons")),
                            ],
                          ),
                          withBorder: true,
                          buttonColor: Colors.white,
                          width: double.infinity,
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: () async {
                            bool notificationAllowed =
                                await Utils.requestNotificationPermission();
                            if (!notificationAllowed) {
                              Alerts.snack(
                                  text: "يجب تفعيل الاشعارات اولا",
                                  state: SnackState.failed);
                              return;
                            }
                            Alerts.dialog(context,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      21.ph,
                                      CustomText(
                                        LocaleKeys.auth_login.tr(),
                                        fontSize: 16,
                                        color: context.primaryColor,
                                        weight: FontWeight.w700,
                                      ),
                                      12.ph,
                                      TextFormFieldWidget(
                                        hintText: "enterUserData".tr(),
                                        password: false,
                                        type: TextInputType.number,
                                        onChanged: (value) {
                                          nationalId = value;
                                        },
                                      ),
                                      30.ph,
                                      ButtonWidget(
                                        title: "checkEmail".tr(),
                                        textColor: Colors.white,
                                        width: double.infinity,

                                        // padding: const EdgeInsets.symmetric(horizontal: 15),
                                        onTap: () async {
                                          //nafath Login
                                          if (nationalId != null) {
                                            Navigator.pop(context);

                                            context
                                                .read<NafathCubit>()
                                                .loginWithNafat(nationalId!);
                                          } else {
                                            Alerts.snack(
                                                text: "يجب ادخل رقم القومي",
                                                state: SnackState.failed);
                                          }
                                          /*   Alerts.snack(
                                                      text: "جاري العمل علي تفعيل الخدمه",
                                                      state: SnackState.failed);
                                                  Navigator.pop(context);*/
                                        },
                                      ),
                                      30.ph,
                                    ],
                                  ),
                                ));
                          },
                        ),
                        40.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              LocaleKeys.auth_havnot_account.tr(),
                              fontSize: 14,
                              color: LightThemeColors.textHint,
                              weight: FontWeight.w400,
                            ),
                            TextButtonWidget(
                                text: LocaleKeys.auth_register_new_acc.tr(),
                                function: () {
                                  Navigator.pushNamed(
                                      context, Routes.RegisterScreen);
                                }),
                          ],
                        ),
                        20.ph,
                        ButtonWidget(
                          title: "visitor".tr(),
                          withBorder: true,
                          buttonColor: Colors.white,
                          textColor: context.primaryColor,
                          borderColor: context.primaryColor,
                          width: double.infinity,

                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: () async {
                            print(Utils.token);
                            Navigator.pushNamed(
                              context,
                              Routes.LayoutScreen,
                            );
                          },
                        ),
                        20.ph,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
