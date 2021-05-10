import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(MyLocationInitial(Model()));

  StreamSubscription<LocationData> _currentLocationSubscription;

  void startFollowing() async {
    Location location = Location();

    location.changeSettings(
      accuracy: LocationAccuracy.navigation,
      interval: 3,
    );

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      final newPos =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      final speed = currentLocation.speed;

      add(OnLocationChange(
        newPos,
        speed,
      ));
    });
  }

  @override
  Future<void> close() {
    _currentLocationSubscription?.cancel();
    return super.close();
  }

  void cancelSubscriptionFromView() {
    _currentLocationSubscription?.cancel();
  }

  @override
  Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {
    if (event is OnLocationChange) {
      yield* _onLocationChange(event);
    }
  }

  Stream<MyLocationState> _onLocationChange(OnLocationChange event) async* {
    yield RefreshLocationState(
      state.model.copyWith(
        location: event.newPos,
        speed: event.speed,
      ),
    );
  }
}
