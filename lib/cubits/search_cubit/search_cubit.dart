import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:route_tracker/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/util/google_map_services.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.googleMapServices) : super(SearchInitial());
  final GoogleMapServices googleMapServices;

  Future<void> searchPlace(
      {required String input, required String seesionToken}) async {
    emit(SearchLoading());
    try {
      var result = await googleMapServices.getPlaces(
          input: input, sessionToken: seesionToken);
      emit(SearchSuccess(placesList: result));
    } on Exception catch (e) {
      emit(SearchFailure(errMessage: '${e.toString()}'));
    }
  }

  // void clearSearchTextFeild() {
  //   emit(SearchSuccess(placesList: []));
  // }

  Future<void> getPlace(
      {required String input, required String sessionToken}) async {
    if (input.isNotEmpty) {
      await searchPlace(input: input, seesionToken: sessionToken);
    } else {
      emit(SearchSuccess(placesList: []));
    }
  }
}
