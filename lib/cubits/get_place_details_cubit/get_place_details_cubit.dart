import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:route_tracker/models/place_details_model/place_details_model.dart';
import 'package:route_tracker/util/api_service.dart';
import 'package:route_tracker/util/google_map_services.dart';

part 'get_place_details_state.dart';

class GetPlaceDetailsCubit extends Cubit<GetPlaceDetailsState> {
  GetPlaceDetailsCubit(this.googleMapServices)
      : super(GetPlaceDetailsInitial());
  final GoogleMapServices googleMapServices;

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    emit(GetPlaceDetailsLoading());
    try {
      var result = await googleMapServices.getPlaceDetails(placeId: placeId);

      emit(GetPlaceDetailsSuccess(placeDetails: result));
      return result;
    } on Exception catch (e) {
      emit(GetPlaceDetailsFailure(errMessage: e.toString()));
      throw Exception('error :${e.toString()}');
    }
  }
}
