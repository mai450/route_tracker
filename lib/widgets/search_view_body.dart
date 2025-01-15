import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:route_tracker/cubits/cubit/make_route_cubit.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/body_routes_service_model/destination.dart';
import 'package:route_tracker/models/body_routes_service_model/lat_lng.dart';
import 'package:route_tracker/models/body_routes_service_model/location.dart';
import 'package:route_tracker/models/body_routes_service_model/origin.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';
import 'package:route_tracker/util/api_service.dart';
import 'package:route_tracker/util/routes_service.dart';
import 'package:route_tracker/widgets/custom_text_field.dart';
import 'package:route_tracker/widgets/search_list.dart';
import 'package:uuid/uuid.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody(
      {super.key, required this.locationData, required this.displayRoutes});
  final LocationData locationData;
  final void Function(List<LatLng>) displayRoutes;

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  late TextEditingController textEditingController;
  String? sesstionToken;
  late Uuid uuid;
  late RoutesService routesService;
  late LatLng destnation;
  Timer? debounce;

  @override
  void initState() {
    textEditingController = TextEditingController();
    uuid = Uuid();
    routesService = RoutesService(apiService: ApiService(dio: Dio()));
    super.initState();
    fetchPlace();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          CustomTextField(
            textEditingController: textEditingController,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(child: SearchList(
            onPlaceSelected: (placeDetailsModel) async {
              textEditingController.clear();
              Navigator.pop(context);
              sesstionToken = null;
              setState(() {});
              destnation = LatLng(placeDetailsModel.geometry!.location!.lat!,
                  placeDetailsModel.geometry!.location!.lng!);
              var points = await getRouteData();
              widget.displayRoutes(points);
            },
          )),
        ],
      ),
    );
  }

  void fetchPlace() {
    textEditingController.addListener(
      () async {
        if (debounce?.isActive ?? false) {
          debounce?.cancel();
        }

        debounce = Timer(
          Duration(milliseconds: 100),
          () {
            sesstionToken ??= uuid.v4();
            // if (textEditingController.text.isNotEmpty) {
            //   BlocProvider.of<SearchCubit>(context).searchPlace(
            //       input: textEditingController.text,
            //       seesionToken: sesstionToken!);
            // } else {
            //   BlocProvider.of<SearchCubit>(context).clearSearchTextFeild();
            // }
            BlocProvider.of<SearchCubit>(context).getPlace(
                input: textEditingController.text,
                sessionToken: sesstionToken!);
          },
        );
      },
    );
  }

  Future<List<LatLng>> getRouteData() async {
    BodyRoutesServiceModel body = BodyRoutesServiceModel(
      origin: Origin(
        location: LocationModel(
          latLng: LatLngModel(
            latitude: widget.locationData.latitude,
            longitude: widget.locationData.longitude,
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
    );

    var route =
        await BlocProvider.of<MakeRouteCubit>(context).fetchRoutes(body: body);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, route);

    return points;
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
