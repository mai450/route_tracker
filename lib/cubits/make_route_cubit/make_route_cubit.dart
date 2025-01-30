import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:route_tracker/models/body_routes_service_model/body_routes_service_model.dart';
import 'package:route_tracker/models/routes_model/routes_model.dart';
import 'package:route_tracker/services/routes_service.dart';

part 'make_route_state.dart';

class MakeRouteCubit extends Cubit<MakeRouteState> {
  MakeRouteCubit(this.routesService) : super(MakeRouteInitial());
  final RoutesService routesService;

  Future<RoutesModel> fetchRoutes(
      {required BodyRoutesServiceModel body}) async {
    try {
      var result = await routesService.fetchRoutes(body: body);
      return result;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
