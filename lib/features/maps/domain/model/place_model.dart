import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../home/domain/model/ads_model.dart';
import 'brokers_model.dart';

class Place with ClusterItem {
  final String name;
  final LatLng latLng;
  final AdsModel ad;

  Place({required this.name, required this.latLng, required this.ad});

  @override
  LatLng get location => latLng;
  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latLng': latLng,
      'ad': ad,
    };
  }
}

class PlaceBroker with ClusterItem {
  final String name;
  final LatLng latLng;
  final BrokerModel broker;

  PlaceBroker({required this.name, required this.latLng, required this.broker});

  @override
  LatLng get location => latLng;
  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latLng': latLng,
      'broker': broker,
    };
  }
}
