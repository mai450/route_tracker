import 'package:route_tracker/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:route_tracker/models/place_details_model/place_details_model.dart';
import 'package:route_tracker/services/api_service.dart';

class GoogleMapServices {
  final ApiService apiService;

  GoogleMapServices({required this.apiService});

  Future<List<PlaceAutocompleteModel>> getPlaces(
      {required String input, required String sessionToken}) async {
    try {
      var result = await apiService.get(
          query: '/autocomplete/json?input=$input&sessiontoken=$sessionToken');
      List<PlaceAutocompleteModel> places = [];
      for (var place in result["predictions"]) {
        places.add(PlaceAutocompleteModel.fromJson(place));
      }
      return places;
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    try {
      var result =
          await apiService.get(query: '/details/json?place_id=$placeId');

      return PlaceDetailsModel.fromJson(result['result']);
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }
}
