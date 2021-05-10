part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class OnMapReady extends MapEvent {}

class OnStartDrawPathAndMeasure extends MapEvent {}

class OnStopDrawPathAndMeasure extends MapEvent {}

class OnAddNewLine extends MapEvent {
  final LatLng pos;
  final GlobalKey markerKey;

  OnAddNewLine({this.pos, this.markerKey});
}
