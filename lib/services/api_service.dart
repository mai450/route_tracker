import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';

class ApiService {
  ApiService({required this.dio});
  final Dio dio;
  final _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final key = 'AIzaSyCWYMBMU45ocQU1FoKUfnZbfHjELWC6Sn0';

  Future<Map<String, dynamic>> get({required String query}) async {
    var response = await dio.get('$_baseUrl$query&key=$key');
    return response.data;
  }

  Future<Map<String, dynamic>> post(
      {required Map<String, String> header,
      required BodyRoutesServiceModel body}) async {
    var response = await dio.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        options: Options(headers: header),
        data: body.toJson());
    return response.data;
  }
}
