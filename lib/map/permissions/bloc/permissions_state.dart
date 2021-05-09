part of 'permissions_bloc.dart';

@immutable
abstract class PermissionsState {
  final Model model;

  PermissionsState(this.model);

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

class PermissionsInitial extends PermissionsState {
  PermissionsInitial(Model model) : super(model);
}

class FetchingPermissionsState extends PermissionsState {
  FetchingPermissionsState(Model model) : super(model);
}

class RefreshPermissionStatus extends PermissionsState {
  RefreshPermissionStatus(Model model) : super(model);
}

class Model {
  final bool gpsEnabled;
  final bool locationPermissionEnabled;

  Model({this.gpsEnabled, this.locationPermissionEnabled});

  Model copyWith({
    bool gpsEnabled,
    bool locationPermissionEnabled,
  }) =>
      Model(
        gpsEnabled: gpsEnabled ?? this.gpsEnabled,
        locationPermissionEnabled:
            locationPermissionEnabled ?? this.locationPermissionEnabled,
      );
}
