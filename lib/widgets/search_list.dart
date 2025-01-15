import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_tracker/cubits/get_place_details_cubit/get_place_details_cubit.dart';
import 'package:route_tracker/cubits/search_cubit/search_cubit.dart';
import 'package:route_tracker/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/models/place_details_model/place_details_model.dart';

class SearchList extends StatelessWidget {
  const SearchList({
    super.key,
    required this.onPlaceSelected,
  });
  final void Function(PlaceDetailsModel) onPlaceSelected;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchSuccess) {
          if (state.placesList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.topLeft, child: Text('No results')),
            );
          }
          return ListView.builder(
            itemCount: state.placesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.location_on),
                title: Text(state.placesList[index].description!),
                trailing: IconButton(
                    onPressed: () async {
                      var placeDetials =
                          await BlocProvider.of<GetPlaceDetailsCubit>(context)
                              .getPlaceDetails(
                                  placeId: state.placesList[index].placeId!);

                      onPlaceSelected(placeDetials);
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded)),
              );
            },
          );
        } else if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchFailure) {
          return Text(state.errMessage);
        } else {
          return SizedBox();
        }
      },
    );
  }
}
