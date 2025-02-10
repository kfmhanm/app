import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:pinput/pinput.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/shared/widgets/customtext.dart';
import '../../../../../core/app_strings/locale_keys.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/text_widget.dart';

class OtpScreen extends StatefulWidget {
  final String sendTo;
  final Function(String code) onSubmit;
  final bool? init;
  final VoidCallback onReSend;
  const OtpScreen({
    super.key,
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>();
  DateTime target = DateTime.now().add(const Duration(minutes: 1));
  DateTime now = DateTime.now();
  Timer? timer;
  String remainigTime = '00:59';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.init == true) widget.onReSend.call();
      startTimer();
    });
    super.initState();
  }

  void startTimer() {
    target = DateTime.now().add(const Duration(minutes: 1));
    now = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (s) {
      if (now.isBefore(target)) {
        now = now.add(const Duration(seconds: 1));
        remainigTime =
            '${target.difference(now).inMinutes}:${target.difference(now).inSeconds.remainder(60)}';
        setState(() {});
      } else {
        remainigTime = '';
        timer!.cancel();
      }
      setState(() {});
    });
  }

  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    timer!.cancel();
    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 80,
        // toolbarHeight: 80,
        leading: BackWidget(
          size: 20,
        ),
        title: CustomText(
          LocaleKeys.auth_otp.tr(),
          fontSize: 18,
          color: context.secondaryColor,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget(
                  LocaleKeys.auth_description_otp.tr(),
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
                24.ph,
                TextWidget(
                  widget.sendTo,
                  fontSize: 14,
                  color: context.primaryColor,
                  fontWeight: FontWeight.w300,
                ),
                40.ph,
                SvgPicture.asset(
                  "otp".svg("icons"),
                  width: 212,
                  height: 212,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      autofocus: false,
                      // errorText: otpError,
                      // onClipboardFound: (s) {},
                      controller: otpController,
                      defaultPinTheme: PinTheme(
                        textStyle: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                        ),
                        width: 54.0,
                        height: 54.0,
                        decoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(.05),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: context.primaryColor,
                            width: 2.0,
                          ),
                          //shape: BoxShape.circle,
                        ),
                      ),
                      followingPinTheme: PinTheme(
                          textStyle: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor),
                          width: 54.0,
                          height: 54.0,
                          decoration: BoxDecoration(
                            color: context.primaryColor.withOpacity(.05),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: context.primaryColor,
                              width: 2.0,
                            ),
                            //shape: BoxShape.circle,
                          )),
                      pinAnimationType: PinAnimationType.scale,
                      validator: Utils.valid.defaultValidation,
                      onCompleted: (pin) async => await widget.onSubmit(pin),
                    ),
                  ),
                ),
                50.ph,
                ButtonWidget(
                  title: LocaleKeys.auth_check.tr(),
                  withBorder: true,
                  buttonColor: Colors.white,
                  textColor: context.secondaryColor,
                  borderColor: context.primaryColor,
                  width: double.infinity,
                  // padding: const EdgeInsets.symmetric(horizontal: 15),
                  onTap: () async {
                    // Navigator.pushNamed(context, Routes.layout);
                    if (formKey.currentState!.validate()) {
                      if (otpController.text.length < 4) {
                        Alerts.snack(
                            text: "الكود غير صحيح", state: SnackState.failed);
                      } else {
                        await widget.onSubmit(otpController.text);
                      }
                    }
                  },
                ),
                16.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    remainigTime.isEmpty
                        ? GestureDetector(
                            child: TextWidget(
                              LocaleKeys.auth_resend.tr(),
                              color: context.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: remainigTime.isEmpty
                                ? () async {
                                    widget.onReSend.call();
                                    remainigTime = '00:59';
                                    setState(() {});
                                    startTimer();
                                  }
                                : null)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                LocaleKeys.auth_resend_code_at.tr(),
                                color: context.primaryColor,
                              ),
                              4.pw,
                              CustomText(
                                '$remainigTime ',
                                color: context.secondaryColor,
                              ),
                            ],
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
