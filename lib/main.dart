import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_tracker/cubits/make_route_cubit/make_route_cubit.dart';
import 'package:route_tracker/util/api_service.dart';
import 'package:route_tracker/util/routes_service.dart';
import 'package:route_tracker/views/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MakeRouteCubit(
            RoutesService(
              apiService: ApiService(
                dio: Dio(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
      ),
    );
  }
}
