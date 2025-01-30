import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/cubits/get_place_details_cubit/get_place_details_cubit.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/services/api_service.dart';
import 'package:route_tracker/services/google_map_services.dart';
import 'package:route_tracker/widgets/search_view_body.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
    required this.locationData,
    required this.polylines,
    required this.googleMapController,
    required this.markers,
    required this.updateMarkers,
  });
  final LatLng locationData;
  final Set<Marker> markers;
  final Function(Set<Marker>) updateMarkers;
  final Set<Polyline> polylines;
  final GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SearchCubit(
                  GoogleMapServices(apiService: ApiService(dio: Dio()))),
            ),
            BlocProvider(
              create: (context) => GetPlaceDetailsCubit(
                  GoogleMapServices(apiService: ApiService(dio: Dio()))),
            ),
          ],
          child: SearchViewBody(
            locationData: locationData,
            googleMapController: googleMapController,
            polylines: polylines,
            markers: markers,
            updateMarkers: updateMarkers,
          ),
        ),
      ),
    );
  }
}
