import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker/util/location_service.dart';
import 'package:route_tracker/views/search_view.dart';
import 'package:route_tracker/widgets/custom_text_field.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialcCameraPosition;
  late GoogleMapController googleMapController;
  late LocationService locationService;
  late LocationData locationData;
  Set<Marker> marker = {};
  Set<Polyline> polylines = {};
  @override
  void initState() {
    super.initState();
    initialcCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 1);
    locationService = LocationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            markers: marker,
            polylines: polylines,
            onMapCreated: (controller) {
              googleMapController = controller;
              updateMyCurrentLocation();
            },
            initialCameraPosition: initialcCameraPosition,
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => SearchView(
                      displayRoutes: displayRoutes,
                      locationData: locationData,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Search here..',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void displayRoutes(List<LatLng> points) {
    Polyline route = Polyline(
        color: Colors.blue,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId('routs'),
        points: points);
    polylines.add(route);

    LatLngBounds bounds = getatLngBounds(points);

    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    setState(() {});
  }

  updateMyCurrentLocation() async {
    try {
      locationData = await locationService.getMyLocation();
      LatLng currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      var myUpdateCamera = CameraPosition(target: currentLocation, zoom: 15);
      var myMarker = Marker(markerId: MarkerId('1'), position: currentLocation);

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(myUpdateCamera));
      marker.add(myMarker);
      setState(() {});
    } on EnableLocationException catch (e) {
      // TODO
    } on PermisssionLocationException catch (e) {
      // TODO
    } catch (e) {
      // TODO
    }
  }

  LatLngBounds getatLngBounds(List<LatLng> points) {
    var southWestLat = points.first.latitude;
    var southWestLng = points.first.longitude;
    var nourthEastLat = points.first.latitude;
    var nourthEastLng = points.first.longitude;

    for (var point in points) {
      southWestLat = min(southWestLat, point.latitude);
      southWestLng = min(southWestLng, point.longitude);
      nourthEastLat = max(nourthEastLat, point.latitude);
      nourthEastLng = max(nourthEastLng, point.longitude);
    }
    return LatLngBounds(
        southwest: LatLng(southWestLat, southWestLng),
        northeast: LatLng(nourthEastLat, nourthEastLng));
  }
}
