part of 'my_location_bloc.dart';

@immutable
abstract class MyLocationEvent {}

class OnLocationChange extends MyLocationEvent {
  final LatLng newPos;

  OnLocationChange(this.newPos);
}
