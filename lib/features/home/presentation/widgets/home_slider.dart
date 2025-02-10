import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../../splash/presentation/screens/on_boarding/widgets/dots.dart';
import '../../domain/model/home_model.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key, this.sliders});
  final List<SlidersModel>? sliders;
  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        CarouselSlider(
          items: List.generate(
            widget.sliders?.length ?? 0,
            (index) => Container(
              width: 400,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    NetworkImagesWidgets(
                      widget.sliders?[index].image ?? "",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            widget.sliders?[index].title ?? "",
                            color: Colors.white,
                            fontSize: 18,
                            weight: FontWeight.w700,
                          ),
                          12.ph,
                          CustomText(
                            widget.sliders?[index].content ?? "",
                            color: Colors.white,
                            fontSize: 16,
                            weight: FontWeight.w700,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              this.index = index;
              setState(() {});
            },
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlayAnimationDuration: Duration(
              seconds: 1,
            ),
            autoPlay: true,
            height: 170,
            viewportFraction: 1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(
            widget.sliders?.length ?? 0,
            (int index) => DotsWidget(
              index: index,
              sliderIndex: this.index,
            ),
          ),
        ).paddingDirectionalOnly(end: 50, bottom: 40),
      ],
    );
  }
}
