import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/Router/Router.dart';
import '../../core/services/alerts.dart';
import '../../core/theme/light_theme.dart';
import 'customtext.dart';

// import 'package:shareet/shared/back_widget.dart';

class WebViewPayment extends StatefulWidget {
  final String url;
  final Function? onPaymentSuccess;

  const WebViewPayment({super.key, required this.url, this.onPaymentSuccess});

  @override
  State<WebViewPayment> createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          'pay'.tr(),
          weight: FontWeight.w800,
          fontSize: 16.0,
          color: LightThemeColors.textPrimary,
        ),
        // leading: const BackWidget(),
      ),
      body: SafeArea(
          child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {
                      debugPrint('''
          Page resource error:
        code: ${error.errorCode}
        description: ${error.description}
        errorType: ${error.errorType}
        isForMainFrame: ${error.isForMainFrame}
              ''');
                    },
                    onNavigationRequest: (NavigationRequest request) {
                      // if (request.url.startsWith('https://www.youtube.com/')) {
                      //   print("fffffffffff");
                      //   return NavigationDecision.prevent;
                      // }

                      // debugPrint(
                      //     "navigation url is ${request.url}");
                      // Uri uri = Uri.parse(request.url);
                      // String? responseCode =
                      //     uri.queryParameters['ResponseCode'];
                      // debugPrint("param1Value $responseCode");
                      // if (responseCode == "000") {
                      //   Utils.showMsg("تم الدفع بنجاح".tr());
                      //   Navigator.pop(context);
                      // }
                      return NavigationDecision.navigate;
                    },
                    onUrlChange: (UrlChange change) async {
                      if (change.url?.contains('status=paid') == true) {
                        Alerts.snack(
                            text: 'payment_success'.tr(),
                            state: SnackState.success);
                        // Utils.userModel.hasPlan = true;
                        if (widget.onPaymentSuccess != null) {
                          Navigator.pop(context);

                          widget.onPaymentSuccess!().call();
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.splashScreen,
                            (route) => false,
                          );
                        }
                      } else if (change.url?.contains("status=failed") ==
                          true) {
                        Alerts.snack(
                            text: 'payment_failed'.tr(),
                            state: SnackState.failed);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.url)))),
    );
  }
}
