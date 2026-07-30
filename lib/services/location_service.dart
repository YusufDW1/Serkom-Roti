// lib/services/location_service.dart
//
// Wraps the geolocator plugin to handle permissions and fetch
// precise GPS coordinates. Used at checkout to capture customer location.

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Checks whether location services are enabled on the device.
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Requests location permission. Returns true if granted.
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Fetches the current device position with high accuracy.
  /// Throws on permission denial or location unavailable.
  Future<Position> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );
    return position;
  }

  /// Convenience: returns (latitude, longitude) tuple.
  Future<(double latitude, double longitude)> getCoordinates() async {
    final position = await getCurrentPosition();
    return (position.latitude, position.longitude);
  }
}
