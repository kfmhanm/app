import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../shared/widgets/loadinganderror.dart';
import 'cubit/map_brokers_cubit.dart';

class MapBroker extends StatefulWidget {
  const MapBroker({super.key});

  @override
  State<MapBroker> createState() => _MapBrokerState();
}

class _MapBrokerState extends State<MapBroker>
    with AutomaticKeepAliveClientMixin {
  @override
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(28.95616385369258, 35.1662814617157);
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => MapBrokersCubit()..getMapAds(context),
      child: BlocConsumer<MapBrokersCubit, MapBrokersState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = MapBrokersCubit.get(context);
          return LoadingAndError(
            isError: state is MapsError,
            isLoading: state is MapsLoading,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                // cubit.controller.complete(controller);
                // cubit.manager?.setMapId(controller.mapId);
              },
              onCameraMove: cubit.manager?.onCameraMove,
              onCameraIdle: cubit.manager?.updateMap,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 5.0,
              ),
              markers: cubit.markersAds,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
