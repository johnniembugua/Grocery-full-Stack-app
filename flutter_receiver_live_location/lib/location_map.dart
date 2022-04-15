import 'dart:async';
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocationMap extends StatefulWidget {
  const LocationMap({Key? key}) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late IO.Socket socket;
  late Map<MarkerId, Marker> _markers;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14);

  @override
  void initState() {
    _markers = <MarkerId, Marker>{};
    _markers.clear();
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io('http://192.168.100.243:3700', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true
      });
      socket.connect();
      socket.on('position-change', (data) async {
        print('connected');
        var latlng = jsonDecode(data);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(latlng['lat'], latlng['lng']), zoom: 19)));
        var image = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)), 'assets/origin.png');
        Marker marker = Marker(
          markerId: const MarkerId('origin'),
          icon: image,
          position: LatLng(latlng['lat'], latlng['lng']),
        );
        setState(() {
          _markers[const MarkerId('origin')] = marker;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers.values.toSet(),
      ),
    );
  }
}
