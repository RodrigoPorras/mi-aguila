part of 'map_bloc.dart';

@immutable
abstract class MapState {
  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

class MapInitialState extends MapState {}
