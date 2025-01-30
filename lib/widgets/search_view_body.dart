import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/services/map_services.dart';
import 'package:route_tracker/widgets/custom_text_field.dart';
import 'package:route_tracker/widgets/search_list.dart';
import 'package:uuid/uuid.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody(
      {super.key,
      required this.locationData,
      required this.polylines,
      required this.googleMapController,
      required this.markers,
      required this.updateMarkers});
  final LatLng locationData;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  final GoogleMapController googleMapController;
  final Function(Set<Marker>) updateMarkers;

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  late TextEditingController textEditingController;
  String? sesstionToken;
  late Uuid uuid;
  LatLng? destnation;
  late MapServices mapServices;
  Timer? debounce;
  late FocusNode _focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    uuid = Uuid();
    super.initState();
    fetchPlace();
    mapServices = MapServices(context: context);
    _focusNode = FocusNode();
    // Request focus when the screen is loaded
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
            text: 'Search here',
            focusNode: _focusNode,
            textEditingController: textEditingController,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(child: SearchList(
            onPlaceSelected: (placeDetailsModel) async {
              textEditingController.clear();
              Navigator.pop(context);
              widget.polylines.clear();
              sesstionToken = null;
              setState(() {});
              destnation = LatLng(placeDetailsModel.geometry!.location!.lat!,
                  placeDetailsModel.geometry!.location!.lng!);

              selectPlace();
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
            BlocProvider.of<SearchCubit>(context).getPlace(
                input: textEditingController.text,
                sessionToken: sesstionToken!);
          },
        );
      },
    );
  }

  void selectPlace() {
    widget.markers.clear();
    mapServices.selectPlace(
      destnation: destnation!,
      googleMapController: widget.googleMapController,
      marker: widget.markers,
      setState: () {
        widget.updateMarkers(widget.markers);
      },
    );
  }
}
