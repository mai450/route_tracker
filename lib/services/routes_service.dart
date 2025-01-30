import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';
import 'package:route_tracker/services/api_service.dart';

class RoutesService {
  final ApiService apiService;

  RoutesService({required this.apiService});

  Future<RoutesModel> fetchRoutes(
      {required BodyRoutesServiceModel body}) async {
    try {
      var result = await apiService.post(header: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiService.key,
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      }, body: body);
      return RoutesModel.fromJson(result);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
