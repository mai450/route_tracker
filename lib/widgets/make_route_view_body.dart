import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/services/map_services.dart';
import 'package:route_tracker/widgets/custom_text_field.dart';
import 'package:route_tracker/widgets/search_list.dart';
import 'package:route_tracker/widgets/traval_mode_list.dart';
import 'package:uuid/uuid.dart';

class MakeRouteViewBody extends StatefulWidget {
  const MakeRouteViewBody(
      {super.key,
      required this.locationData,
      required this.polylines,
      required this.googleMapController,
      required this.markers,
      required this.updateMarkers,
      required this.updatePolylines,
      required this.isRouteFocused,
      required this.routeDetails});
  final LatLng locationData;
  final Set<Polyline> polylines;
  final Set<Marker> markers;
  final Function(Set<Polyline>) updatePolylines;
  final GoogleMapController googleMapController;
  final Function(Set<Marker>) updateMarkers;
  final bool isRouteFocused;
  final Function(String duration, String distance) routeDetails;
  @override
  State<MakeRouteViewBody> createState() => _MakeRouteViewBodyState();
}

class _MakeRouteViewBodyState extends State<MakeRouteViewBody> {
  late TextEditingController textEditingController;
  String? sesstionToken;
  late Uuid uuid;
  late LatLng destnation;
  late MapServices mapServices;
  Timer? debounce;
  late FocusNode _focusNode;
  late String duration;
  late String distance;
  String selectedTravalMode = 'DRIVE';
  @override
  void initState() {
    textEditingController = TextEditingController();
    uuid = Uuid();
    super.initState();
    fetchPlace();
    mapServices = MapServices(context: context);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce!.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          CustomTextField(
            text: 'Select place',
            focusNode: _focusNode,
            textEditingController: textEditingController,
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 50,
              child: TravalModeList(
                onTravalModeSelected: (selectedMode) {
                  selectedTravalMode = selectedMode;
                },
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(child: SearchList(
            onPlaceSelected: (placeDetailsModel) async {
              textEditingController.clear();
              Navigator.pop(context);
              sesstionToken = null;
              setState(() {});
              destnation = LatLng(placeDetailsModel.geometry!.location!.lat!,
                  placeDetailsModel.geometry!.location!.lng!);

              mapServices.setMarker(
                  destnation: destnation,
                  currentLocation: widget.locationData,
                  marker: widget.markers,
                  setState: () {
                    widget.updateMarkers(widget.markers);
                  });
              await fetchRouteDetails();
            },
          )),
        ],
      ),
    );
  }

  Future<void> fetchRouteDetails() async {
    var routeDetails = await mapServices.getRouteData(
      travaleMode: selectedTravalMode,
      currentLocation: widget.locationData,
      destnation: destnation,
    );
    duration = routeDetails["duration"];
    distance = routeDetails["distance"];
    List<LatLng> points = routeDetails["points"];
    mapServices.displayRoutes(points, widget.polylines,
        widget.googleMapController, widget.isRouteFocused);
    widget.updatePolylines(widget.polylines);
    widget.routeDetails(duration, distance);
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
            BlocProvider.of<SearchCubit>(context).getPlace(
                input: textEditingController.text,
                sessionToken: sesstionToken!);
          },
        );
      },
    );
  }
}
