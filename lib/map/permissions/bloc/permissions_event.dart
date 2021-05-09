part of 'permissions_bloc.dart';

@immutable
abstract class PermissionsEvent {}

class OnFetchPermissionStatusEvent extends PermissionsEvent {}

class OnRequestLocationPermission extends PermissionsEvent {}

class OnRefreshGPSStatus extends PermissionsEvent {
  final bool status;

  OnRefreshGPSStatus({this.status});
}
