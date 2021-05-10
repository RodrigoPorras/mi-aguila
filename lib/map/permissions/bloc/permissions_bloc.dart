import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:location_permissions/location_permissions.dart'
    as l_permissions;
import 'package:location/location.dart' as location;

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  StreamSubscription<bool> gpsStatusSubs;

  PermissionsBloc() : super(PermissionsInitial(Model())) {
    final gpsStatusStream = l_permissions.LocationPermissions()
        .serviceStatus
        .map((s) => s == l_permissions.ServiceStatus.enabled);

    gpsStatusSubs = gpsStatusStream.listen((status) {
      add(OnRefreshGPSStatus(status: status));
    });
  }

  @override
  Future<void> close() {
    gpsStatusSubs?.cancel();
    return super.close();
  }

  @override
  Stream<PermissionsState> mapEventToState(PermissionsEvent event) async* {
    if (event is OnFetchPermissionStatusEvent) {
      yield* _onFetchPermissionStatusEvent(event);
    } else if (event is OnRequestLocationPermission) {
      yield* _onRequestLocationPermission(event);
    } else if (event is OnRefreshGPSStatus) {
      yield* _onRefreshGPSStatus(event);
    }
  }

  Stream<PermissionsState> _onRefreshGPSStatus(
      OnRefreshGPSStatus event) async* {
    yield RefreshPermissionStatus(
        state.model.copyWith(gpsEnabled: event.status));
  }

  Stream<PermissionsState> _onRequestLocationPermission(
      OnRequestLocationPermission event) async* {
    final requestResponse = await Permission.location.request();

    switch (requestResponse) {
      case PermissionStatus.granted:
        yield RefreshPermissionStatus(
            state.model.copyWith(locationPermissionEnabled: true));
        break;
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
      default:
    }
  }

  Stream<PermissionsState> _onFetchPermissionStatusEvent(
      OnFetchPermissionStatusEvent event) async* {
    yield FetchingPermissionsState(state.model.copyWith());

    final locationStatus = await Permission.location.isGranted;
    final gpsStatus = await location.Location().serviceEnabled();

    yield RefreshPermissionStatus(
      state.model.copyWith(
        locationPermissionEnabled: locationStatus,
        gpsEnabled: gpsStatus,
      ),
    );
  }
}
