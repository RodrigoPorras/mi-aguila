part of 'my_location_bloc.dart';

@immutable
abstract class MyLocationEvent {}

class OnLocationChange extends MyLocationEvent {
  final LatLng newPos;
  final double speed;

  OnLocationChange(this.newPos, this.speed);
}
