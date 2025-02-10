import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide Cluster, ClusterManager;
import 'package:meta/meta.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

import '../../../../../../core/utils/Locator.dart';
import '../../../../../../core/utils/utils.dart';
import '../../../../../../shared/widgets/customtext.dart';
import '../../../../../home/domain/model/ads_model.dart';
import '../../../../../my_ads/domain/model/my_ads_model.dart';
import '../../../../domain/model/maps_model.dart';
import '../../../../domain/model/place_model.dart';
import '../../../../domain/repository/repository.dart';
import '../../../widgets/widgets.dart';

part 'map_order_state.dart';

class MapOrderCubit extends Cubit<MapOrderState> {
  MapOrderCubit() : super(MapOrderInitial());
  static MapOrderCubit get(context) => BlocProvider.of(context);

  MapsRepository mapsRepository = locator<MapsRepository>();
  ClusterManager? manager;

  Completer<GoogleMapController> controller = Completer();
  getMapAds() async {
    emit(MapsLoading());
    final response = await mapsRepository.getMapOrder();
    if (response != null) {
      markersAds = {};
      items = [];

      await addMarkers(response);

      manager = _initClusterManager();

      emit(MapsSuccess(response));
    } else {
      emit(MapsError());
    }
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    this.markersAds = markers;
    emit(Update());
  }

  Set<Marker> markersAds = {};
  List<Place> items = [];
  late Future<Marker> Function(Cluster<Place>) item;

  Future<Marker> _markerBuilder(Cluster<Place> cluster) async {
    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      onTap: () {
        List<AdsModel> a = [];
        cluster.items.forEach((element) {
          a.add(element.ad);
        });
        _onClusterTap(a);
        a.forEach((element) {
          print("element ${element.toJson()}");
        });
        //  print("cluster.ad ${cluster.}");
        print('---- $cluster');
        print('---- ${cluster.items.length}');
        cluster.items.forEach((p) => print("ppppp ${p.ad.title}   ${p}"));
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

  void _onClusterTap(List<AdsModel> cluster) {
    // Show bottom sheet with list of ads
    /*   Alerts.bottomSheet(
      Utils.navigatorKey().currentContext!,
      useRootNavigator: false,
      useExpand: true,
      child: DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: [
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                  ),10.ph,
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider().paddingAll(4),
                  controller: scrollController,
                  itemCount: cluster.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = cluster[index];
                    return AdWidget(
                      adsModel: item,
                      favTap: () async {
                        item.isFavorite = !(item.isFavorite ?? false);
                        emit(Update());
                        final res =
                            await locator<GeneralRepo>().toggleFavorite(item.id);
                        if (res != true) {
                          item.isFavorite = !(item.isFavorite ?? false);
                          emit(Update());
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
     */
    showModalBottomSheet(
      context: Utils.navigatorKey().currentContext!,
      builder: (BuildContext context) {
        return AdsBottomSheet(
          ads: cluster,
        );
      },
    );
  }

  addMarkers(PaginatedAds? response) async {
    for (AdsModel e in response?.myads ?? []) {
      items.add(Place(
        // id: e.id,
        name: e.title ?? "",
        latLng: LatLng(
          double.parse(e.location?.lat ?? "20"),
          double.parse(e.location?.lng ?? "20"),
        ),
        ad: e,
        // lat: double.parse(e.location?.lat ?? "20"),
        // lng: double.parse(e.location?.lng ?? "20"),
        // count: e.details?.count,
      ));
      // markersAds.add(
      //   Marker(
      //     markerId: MarkerId(e.id.toString() ?? "0"),
      //     position: LatLng(double.parse(e.location?.lat ?? "20"),
      //         double.parse(e.location?.lng ?? "20")),

      //     icon: await CircleAvatar(
      //       backgroundColor:
      //           Utils.navigatorKey().currentContext?.primaryColor,
      //       radius: 20,
      //       child: CustomText(
      //         /* e.details?.count?.toString() ?? */ "١",
      //         fontSize: 20,
      //         color: Colors.white,
      //         weight: FontWeight.w700,
      //       ),
      //     ).toBitmapDescriptor(),
      //   ),
      // );
    }
  }
}
