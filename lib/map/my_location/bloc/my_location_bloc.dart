import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';

class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(MyLocationInitial(Model()));

  StreamSubscription<Position> _currentLocationSubscription;

  void startFollowing() async {
    _currentLocationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((position) {
      final newPos = LatLng(position.latitude, position.longitude);
      add(OnLocationChange(newPos));
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
    yield RefreshLocationState(state.model.copyWith(location: event.newPos));
  }
}
