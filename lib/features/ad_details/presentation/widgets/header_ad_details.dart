import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/extensions/all_extensions.dart';

import '../../../../shared/back_widget.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../../../shared/widgets/video_player_widget.dart';
import '../../../splash/presentation/screens/on_boarding/widgets/dots.dart';
import '../../domain/model/ad_details_model.dart';

class HeaderAdDetails extends StatefulWidget {
  const HeaderAdDetails({
    super.key,
    required this.sliders,
    required this.innerBoxIsScrolled,
  });
  final bool innerBoxIsScrolled;
  final List<ImagesModel> sliders;

  @override
  State<HeaderAdDetails> createState() => _HeaderAdDetailsState();
}

class _HeaderAdDetailsState extends State<HeaderAdDetails> {
  int indexCrsoul = 0;
  double heightSection = 400;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Opacity(
        child: BackWidget(
          color: Colors.black,
          onBack: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.LayoutScreen, (s) => false);
            }
          },
          size: 20,
        ),
        opacity: widget.innerBoxIsScrolled ? 1 : 0,
      ),
      floating: true,
      pinned: true,
      expandedHeight: heightSection - 100,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          height: heightSection,
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: heightSection,
                  autoPlay: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  aspectRatio: 1.5,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, reason) {
                    // cubit.changeSlider(index);
                    indexCrsoul = index;
                    setState(() {});
                  },
                ),
                items: List.generate(
                  widget.sliders.length,
                  (index) => SizedBox(
                    height: heightSection,
                    // width: double.infinity,

                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(
                          15,
                        ),
                      ),
                      child: widget.sliders[index].file_type
                                  ?.toLowerCase()
                                  .contains("video") ==
                              true
                          ? VideoPlayerWidget(
                              videoLink: widget.sliders[index].video ?? "",
                            )
                          : NetworkImagesWidgets(
                              widget.sliders[index].url ?? "",
                              fit: BoxFit.cover,
                              height: heightSection,
                              width: double.infinity,
                            ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 70,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(.8),
                      child: BackWidget(
                        color: Colors.black,
                        onBack: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.LayoutScreen, (s) => false);
                          }
                        },
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.sliders.length,
                    (int index) => DotsWidget(
                      index: index,
                      sliderIndex: indexCrsoul,
                    ),
                  ),
                ).paddingDirectionalOnly(end: 50, bottom: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
