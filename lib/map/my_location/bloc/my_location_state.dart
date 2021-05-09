part of 'my_location_bloc.dart';

@immutable
abstract class MyLocationState {
  final Model model;

  MyLocationState(this.model);
}

class MyLocationInitial extends MyLocationState {
  MyLocationInitial(Model model) : super(model);
}

class RefreshLocationState extends MyLocationState {
  RefreshLocationState(Model model) : super(model);
}

class Model {
  final LatLng location;

  Model({
    this.location,
  });

  Model copyWith({
    LatLng location,
    ScreenCoordinate screenPos,
  }) =>
      Model(
        location: location ?? this.location,
      );
}
