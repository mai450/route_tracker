import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/views/search_view.dart';

class SearchContainer extends StatelessWidget {
  SearchContainer(
      {super.key,
      required this.duration,
      required this.distance,
      required this.locationData,
      required this.markers,
      required this.updateMarkers,
      required this.polylines,
      required this.googleMapController});

  final Function(String?) duration;
  final Function(String?) distance;
  final LatLng locationData;
  final Set<Marker> markers;
  final Function(Set<Marker>) updateMarkers;
  final Set<Polyline> polylines;
  final GoogleMapController googleMapController;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          duration(null);
          distance(null);
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => SearchView(
                googleMapController: googleMapController,
                polylines: polylines,
                //displayRoutes: mapServices.displayRoutes,
                locationData: locationData,
                markers: markers,
                updateMarkers: updateMarkers,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(14),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.green[700],
                size: 22,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Search here',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
