import 'package:dio/dio.dart';
import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';
import 'package:route_tracker/util/api_service.dart';

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
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Handle 404 specifically
        print('Resource not found');
        throw Exception('Resource not found: ${e.message}');
      } else {
        rethrow; // Re-throw other exceptions
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
