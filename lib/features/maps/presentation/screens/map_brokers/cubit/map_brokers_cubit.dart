import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/context_extensions.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/features/maps/domain/model/brokers_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide Cluster, ClusterManager;
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart' /*  as cls */;
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../../../../core/Router/Router.dart';
import '../../../../../../core/app_strings/locale_keys.dart';
import '../../../../../../core/general/general_repo.dart';
import '../../../../../../core/services/alerts.dart';
import '../../../../../../core/utils/Locator.dart';
import '../../../../../../shared/widgets/customtext.dart';
import '../../../../../../shared/widgets/webview_payment.dart';
import '../../../../../ad_details/domain/repository/repository.dart';
import '../../../../domain/model/place_model.dart';
import '../../../../domain/repository/repository.dart';

part 'map_brokers_state.dart';

class MapBrokersCubit extends Cubit<MapBrokersState> {
  MapBrokersCubit() : super(MapBrokersInitial());
  static MapBrokersCubit get(context) => BlocProvider.of(context);

  MapsRepository mapsRepository = locator<MapsRepository>();
  ClusterManager? manager;

  Completer<GoogleMapController> controller = Completer();
  getMapAds(
    BuildContext context,
  ) async {
    emit(MapsLoading());
    final response = await mapsRepository.getMapBrokers();
    if (response != null) {
      markersAds = {};
      items = [];

      await addMarkers(response, context);

      // manager = _initClusterManager();

      emit(MapsSuccess(response));
    } else {
      emit(MapsError());
    }
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<PlaceBroker>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    this.markersAds = markers;
    emit(Update());
  }

  Set<Marker> markersAds = {};
  List<PlaceBroker> items = [];
  late Future<Marker> Function(Cluster<PlaceBroker>) item;

  Future<Marker> _markerBuilder(Cluster<PlaceBroker> cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      onTap: () {
        List<BrokerModel> a = [];
        cluster.items.forEach((element) {
          a.add(element.broker);
        });
        _onClusterTap(a);
        a.forEach((element) {
          print("element ${element.toJson()}");
        });
        //  print("cluster.ad ${cluster.}");
        print('---- $cluster');
        print('---- ${cluster.items.length}');
        cluster.items.forEach((p) => print("ppppp ${p.broker.name}   ${p}"));
      },
      icon: await _createClusterIcon(cluster),
      // icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
      //     text: cluster.isMultiple ? cluster.count.toString() : null),
    );
  }

  Future<BitmapDescriptor> _createClusterIcon(cluster) async {
    return await CircleAvatar(
      radius: 20,
      backgroundColor: Color(0xff3576BA),
      child: CustomText(
        cluster.isMultiple ? cluster.count.toString() : "1",
        fontSize: 20,
        color: Colors.white,
        weight: FontWeight.w700,
      ),
    ).toBitmapDescriptor();
  }

  void _onClusterTap(List<BrokerModel> cluster) {
    //TODO showModalBottomSheet(
    //   context: Utils.navigatorKey().currentContext!,
    //   builder: (BuildContext context) {
    //     return AdsBottomSheet(
    //       ads: cluster,
    //     );
    //   },
    // );
  }

  addMarkers(BrokersModel? response, BuildContext context) async {
    for (BrokerModel e in response?.brokers ?? []) {
      // items.add(PlaceBroker(
      //   // id: e.id,
      //   name: e.name ?? "",
      //   latLng: LatLng(
      //     double.parse(e.location?.lat ?? "20"),
      //     double.parse(e.location?.lng ?? "20"),
      //   ),
      //   broker: e,
      //   // lat: double.parse(e.location?.lat ?? "20"),
      //   // lng: double.parse(e.location?.lng ?? "20"),
      //   // count: e.details?.count,
      // ));
      markersAds.add(
        Marker(
          onTap: () async {
            if (e.id == null || e.id == Utils.userModel.id) return;
            if (e.has_chat == true) {
              Navigator.pushNamed(
                  Utils.navigatorKey().currentContext!, Routes.ChatScreen,
                  arguments: {
                    "roomId": e.room_id?.toString() ?? "",
                  });
            } else {
              Alerts.yesOrNoDialog(Utils.navigatorKey().currentContext!,
                  title: LocaleKeys.chat_cost.tr(),
                  action2Color:
                      Utils.navigatorKey().currentContext!.primaryColor,
                  content: LocaleKeys.pay_consultation_cost.tr(),
                  action1title: LocaleKeys.no.tr(),
                  action2title: LocaleKeys.pay.tr(), action2: () async {
                final res = await startChat(e.id?.toString() ?? "");
                if (res != null) {
                  Navigator.push(
                      Utils.navigatorKey().currentContext!,
                      MaterialPageRoute(
                          builder: (ctx) => WebViewPayment(
                                url: res,
                                onPaymentSuccess: () async {
                                  final roomId = await locator<GeneralRepo>()
                                      .getRoomId(
                                          brokerId: e.id?.toString() ?? "");
                                  if (res != null) {
                                    e.room_id = roomId;
                                    e.has_chat = true;
                                    Navigator.pushNamed(
                                        context, Routes.ChatScreen,
                                        arguments: {
                                          "roomId": roomId,
                                        });
                                  }
                                },
                              )));
                }
              });
            }
          },
          markerId: MarkerId(e.id.toString() ?? "0"),
          position: LatLng(double.parse(e.location?.lat ?? "20"),
              double.parse(e.location?.lng ?? "20")),
          icon: await ClipOval(
            // backgroundColor:
            // Utils.navigatorKey().currentContext?.primaryColor,
            child: Image.network(
              e.image ?? ""
              // "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.facebook.com%2Fphoto.php%3Ffbid%3D4139254799433784%26id%3D1474343352591622%26set%3Da.2450735501619064%26locale%3Dde_DE&psig=AOvVaw160O0tdUiaVWcg_c__L4CV&ust=1728915169785000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCMjZ7obFi4kDFQAAAAAdAAAAABAE"
              // fontSize: 20,
              ,
              width: 42,
              height: 42,
              // color: Colors.white,
              // weight: FontWeight.w700,
            ),
          ).toBitmapDescriptor(),
        ),
      );
    }
  }

  startChat(String brokerId) async {
    final response = await locator<AdDetailsRepository>().startChat(brokerId);
    if (response != null) {
      return response;
    }
  }
}
