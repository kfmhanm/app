import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';

class AboutUS extends StatefulWidget {
  const AboutUS({super.key, required this.type, required this.title});
  final String type;
  final String title;

  @override
  State<AboutUS> createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  late Future<dynamic> data;
  @override
  void initState() {
    data = getAboutUs();
    super.initState();
  }

  Future getAboutUs() async {
    final response = await locator<StaticPageRepository>().aboutUs(widget.type);
    title = response?["title"] ?? "";
    setState(() {});

    return response;
  }

  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: title.isEmpty ? widget.title.tr() : title,
      ),
      // body: Column(
      //   children: [
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     // const AppLogo(),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: CustomText(
      //         "aboutUsText".tr(),
      //         align: TextAlign.center,
      //         color: Colors.black,
      //         fontSize: 20,
      //       ),
      //     ),
      //   ],
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              // print(snapshot.data);

              return LoadingAndError(
                      isError: snapshot.hasError && snapshot.data == null,
                      isLoading: snapshot.connectionState ==
                              ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.active,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            24.ph,
                            // NetworkImagesWidgets(
                            //   snapshot.data?["image"] ?? "",
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 200,
                            //   fit: BoxFit.cover,
                            // ),
                            // 22.ph,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: HtmlWidget(
                                  snapshot.data?["content"]?.toString() ?? ""),
                            ),
                            24.ph,
                          ],
                        ),
                      )) /* snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: MyLoading.loadingWidget(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        24.ph,
                        NetworkImagesWidgets(
                          snapshot.data?["image"],
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        22.ph,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: HtmlWidget(
                              snapshot.data?["content"]?.toString() ?? ""),
                        ),
                      ],
                    ) */
                  ;
            }),
      ),
    );
  }
}
