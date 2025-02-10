import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../shared/widgets/customtext.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(24.774265, 46.738586);

  LatLng? _lastMapPosition;
  Marker marker = Marker(
      markerId: MarkerId('selectedLocation'),
      position: LatLng(24.774265, 46.738586));

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Position? _currentPosition;
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  List<Placemark> placemarks = [];
  void _onMapTapped(LatLng location) async {
    _lastMapPosition = location;
    mapController.animateCamera(CameraUpdate.newLatLng(location));

    setState(() {});
  }

  _getCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

// get location permission

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText('selectlocation'.tr()),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 9.0,
        ),
        onTap: _onMapTapped,
        onCameraMove: _onCameraMove,
        markers: _lastMapPosition != null
            ? {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _lastMapPosition!,
                ),
              }
            : {},
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: null,
            heroTag: null,
            onPressed: () async {
              await _getCurrentLocation();
              if (_currentPosition != null) {
                _lastMapPosition = LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude);
                mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude)));
                setState(() {});
              }
            },
            tooltip: 'get current Location',
            child: Icon(Icons.location_on),
          ),
          8.ph,
          FloatingActionButton.extended(
            label: CustomText('selectlocation'.tr()),
            key: null,
            heroTag: null,
            onPressed: () async {
              if (_lastMapPosition != null) {
                placemarks = await placemarkFromCoordinates(
                  _lastMapPosition!.latitude,
                  _lastMapPosition!.longitude,
                );
                Navigator.pop(context, [_lastMapPosition, placemarks]);
              }
            },
            tooltip: 'selectlocation'.tr(),
            // child: Icon(
            //   Icons.flag,
            // ),
            //  CustomText('أختر الموقع'.tr()),
          ),
        ],
      ),
    );
  }
}
