import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<void> checkAndRequestEnableLocation() async {
    var isLocationEnable = await location.serviceEnabled();
    if (!isLocationEnable) {
      isLocationEnable = await location.requestService();
      if (!isLocationEnable) {
        throw EnableLocationException();
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    var permissionStatues = await location.hasPermission();
    if (permissionStatues == PermissionStatus.deniedForever) {
      throw PermisssionLocationException();
    }
    if (permissionStatues == PermissionStatus.denied) {
      permissionStatues = await location.requestPermission();
      if (permissionStatues != PermissionStatus.granted) {
        throw PermisssionLocationException();
      }
    }
  }

  Future<void> getRealTimeLocation(
    void Function(LocationData)? onData,
  ) async {
    await checkAndRequestEnableLocation();
    await checkAndRequestLocationPermission();
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getMyLocation() async {
    await checkAndRequestEnableLocation();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class EnableLocationException implements Exception {}

class PermisssionLocationException implements Exception {}
