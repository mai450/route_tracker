import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/cubits/make_route_cubit/make_route_cubit.dart';
import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/body_routes_service_model/destination.dart';
import 'package:route_tracker/models/body_routes_service_model/lat_lng.dart';
import 'package:route_tracker/models/body_routes_service_model/location.dart';
import 'package:route_tracker/models/body_routes_service_model/origin.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';
import 'package:route_tracker/services/location_service.dart';

class MapServices {
  final BuildContext context;

  LocationService locationService = LocationService();
  // LatLng? currentLocation;

  MapServices({required this.context});

  void selectPlace(
      {required LatLng destnation,
      required GoogleMapController googleMapController,
      required Set<Marker> marker,
      required Function setState}) {
    marker.clear();
    var myMarker = Marker(markerId: MarkerId('1'), position: destnation);

    marker.add(myMarker);
    googleMapController.animateCamera(CameraUpdate.newLatLng(destnation));
    setState();
  }

  void setMarker(
      {required LatLng destnation,
      required LatLng currentLocation,
      required Set<Marker> marker,
      required Function setState}) {
    marker.clear();
    var currentLocationMarker =
        Marker(markerId: MarkerId('1'), position: currentLocation);
    var destnationMarker = Marker(
      markerId: MarkerId('2'),
      position: destnation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      // infoWindow: InfoWindow(title: 'Blue Marker'),
    );

    marker.add(destnationMarker);
    marker.add(currentLocationMarker);

    setState();
  }

  void displayRoutes(
    List<LatLng> points,
    Set<Polyline> polylines,
    GoogleMapController googleMapController,
    bool isRouteFocused,
  ) {
    isRouteFocused = true;
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

  Future<Map<String, dynamic>> getRouteData({
    required LatLng currentLocation,
    required LatLng destnation,
    required String travaleMode,
  }) async {
    BodyRoutesServiceModel body = BodyRoutesServiceModel(
        origin: Origin(
          location: LocationModel(
            latLng: LatLngModel(
              latitude: currentLocation.latitude,
              longitude: currentLocation.longitude,
            ),
          ),
        ),
        destination: Destination(
          location: LocationModel(
            latLng: LatLngModel(
              latitude: destnation.latitude,
              longitude: destnation.longitude,
            ),
          ),
        ),
        travelMode: travaleMode);

    RoutesModel route =
        await BlocProvider.of<MakeRouteCubit>(context).fetchRoutes(body: body);
    //String duration = route.routes!.first.duration!;

    String duration = route.routes!.first.duration!; // Example: "262s"

// Remove the 's' suffix or any non-numeric characters
    String numericDuration = duration.replaceAll(RegExp(r'[^0-9]'), '');

// Parse the numeric string into an integer and convert it to Duration
    Duration durationSecond = Duration(seconds: int.parse(numericDuration));

// Convert the duration to minutes
    String durationMinutes = "${durationSecond.inMinutes.toString()}m";
    String distance = "${route.routes!.first.distanceMeters.toString()}m";
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, route);

    return {
      "duration": durationMinutes,
      "distance": distance,
      "points": points,
    };
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel route) {
    List<PointLatLng> result = polylinePoints
        .decodePolyline(route.routes!.first.polyline!.encodedPolyline!);

    List<LatLng> points = result
        .map(
          (e) => LatLng(e.latitude, e.longitude),
        )
        .toList();
    return points;
  }
}
