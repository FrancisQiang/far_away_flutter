

import 'package:geolocator/geolocator.dart';

import 'navigator_util.dart';

class LocationUtil {

  /// 获取定位
  static getLocation(context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    Position position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    NavigatorUtil.toLocationChoosePage(context,
        longitude: position.longitude.toString(),
        latitude: position.latitude.toString());
  }

}