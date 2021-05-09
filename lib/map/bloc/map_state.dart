part of 'map_bloc.dart';

@immutable
abstract class MapState {
  final Model model;

  MapState(this.model);

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

class MapInitialState extends MapState {
  MapInitialState(Model model) : super(model);
}

class RefreshMapState extends MapState {
  RefreshMapState(Model model) : super(model);
}

class Model {
  final bool mapReady;
  final bool drawPathAndMeasure;
  final Polyline polyline;
  final ScreenPosition screenPos;

  Model({
    this.mapReady = false,
    this.drawPathAndMeasure = false,
    this.polyline,
    this.screenPos,
  });

  Model copyWith({
    bool mapReady,
    bool drawPathAndMeasure,
    Polyline polyline,
    ScreenPosition screenPos,
  }) =>
      Model(
        mapReady: mapReady ?? this.mapReady,
        drawPathAndMeasure: drawPathAndMeasure ?? this.drawPathAndMeasure,
        polyline: polyline ?? this.polyline,
        screenPos: screenPos ?? this.screenPos,
      );
}

class ScreenPosition {
  final double x;
  final double y;

  ScreenPosition({this.x, this.y});
}
