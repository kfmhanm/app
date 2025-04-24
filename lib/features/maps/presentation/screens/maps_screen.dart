
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';

import 'map_ads.dart';
import 'map_brokers/map_broker.dart';
import 'map_orders/map_order.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with SingleTickerProviderStateMixin {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(28.95616385369258, 35.1662814617157);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: DefaultAppBar(
          titleAppBar: LocaleKeys.ads_on_map.tr(),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MapAds(),
                  MapOrder(),
                  MapBroker(),
                ],
              ),
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    width: 280,
                    child: TabBar(
                      splashBorderRadius: BorderRadius.circular(15),
                      tabs: [
                        Tab(
                          text: LocaleKeys.ads.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.requests.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.real_estate_agents.tr(),
                        ),
                      ],
                      dividerHeight: 0,
                      labelColor: Colors.white,
                      unselectedLabelColor: Color(0xff818181),
                      indicatorColor: context.primaryColor,
                      indicator: CustomTabIndicator(
                          color: Theme.of(context).primaryColor),
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  final BoxPainter _painter;

  CustomTabIndicator({required Color color}) : _painter = _CustomPainter(color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CustomPainter extends BoxPainter {
  final Paint _paint;

  _CustomPainter(Color color)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Offset(offset.dx - 22, 0) &
        Size(cfg.size!.width + 48, cfg.size!.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(15)),
      _paint,
    );
  }
}
