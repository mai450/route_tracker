import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker/cubits/get_place_details_cubit/get_place_details_cubit.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/util/api_service.dart';
import 'package:route_tracker/util/google_map_services.dart';
import 'package:route_tracker/widgets/search_view_body.dart';

class SearchView extends StatelessWidget {
  const SearchView(
      {super.key, required this.locationData, required this.displayRoutes});
  final LocationData locationData;
  final void Function(List<LatLng>) displayRoutes;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            displayRoutes: displayRoutes,
          ),
        ),
      ),
    );
  }
}
