import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/util/location_service.dart';
import 'package:route_tracker/util/map_services.dart';
import 'package:route_tracker/views/directions_view.dart';
import 'package:route_tracker/widgets/custom_floating_action_button.dart';
import 'package:route_tracker/widgets/route_details_googlemap_view.dart';
import 'package:route_tracker/widgets/search_container_google_map_view.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initialcCameraPosition;
  GoogleMapController? googleMapController;
  late LocationService locationService;
  late MapServices mapServices;
  LatLng? currentLocation;
  Set<Marker> marker = {};
  Set<Marker> directionsMarker = {};
  Set<Polyline> polylines = {};
  bool isRouteFocused = false;
  String? duration;
  String? distance;

  @override
  void initState() {
    super.initState();
    initialcCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 1);
    locationService = LocationService();
    mapServices = MapServices(context: context);
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
            if (googleMapController != null && currentLocation != null)
              SearchContainer(
                googleMapController: googleMapController!,
                polylines: polylines,
                locationData: currentLocation!,
                markers: marker,
                updateMarkers: updateMarkers,
                distance: (value) {
                  distance = value;
                },
                duration: (value) {
                  duration = value;
                },
              ),
            if (duration != null && distance != null)
              RouteDetails(
                distance: distance!,
                duration: duration!,
              ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomFloatingActionButton(
              heroTag: 'getLocation',
              btnColor: Colors.grey.shade100,
              icon: Icons.location_pin,
              iconColor: Colors.black54,
              onPressed: () {
                marker.clear();
                polylines.clear();
                distance = null;
                duration = null;
                updateMyCurrentLocation();
              },
            ),
            CustomFloatingActionButton(
              heroTag: 'makeRoute',
              btnColor: Colors.green.shade700,
              icon: Icons.directions,
              shape: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DirectionsView(
                      routeDetails: updateRouteDetails,
                      isRouteFocused: isRouteFocused,
                      updatePolylines: updatePolylines,
                      updateMarkers: updateMarkers,
                      googleMapController: googleMapController!,
                      locationData: currentLocation!,
                      markers: marker,
                      polylines: polylines,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }

  void updateMyCurrentLocation() async {
    try {
      locationService.getRealTimeLocation(
        (locationData) {
          if (!isRouteFocused) {
            currentLocation =
                LatLng(locationData.latitude!, locationData.longitude!);
            var myUpdateCamera =
                CameraPosition(target: currentLocation!, zoom: 15);
            var myMarker =
                Marker(markerId: MarkerId('1'), position: currentLocation!);

            googleMapController
                ?.animateCamera(CameraUpdate.newCameraPosition(myUpdateCamera));
            marker.add(myMarker);
            setState(() {});
          }
        },
      );
    } on EnableLocationException catch (e) {
      // TODO
    } on PermisssionLocationException catch (e) {
      // TODO
    } catch (e) {
      // TODO
    }
  }

  void updateMarkers(Set<Marker> updatedMarkers) {
    setState(() {
      marker = updatedMarkers;
    });
  }

  void updatePolylines(Set<Polyline> updatedPolylines) {
    setState(() {
      polylines = updatedPolylines;
    });
  }

  void updateRouteDetails(String newDuration, String newDistance) {
    setState(() {
      duration = newDuration;
      distance = newDistance;
    });
  }
}
