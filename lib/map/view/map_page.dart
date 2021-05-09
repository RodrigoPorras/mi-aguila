import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mi_aguila/l10n/l10n.dart';
import 'package:mi_aguila/map/permissions/bloc/permissions_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsBloc>().add(OnFetchPermissionStatusEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2ed29e),
        centerTitle: true,
        title: Text(l10n.titleMapScreen),
      ),
      body: SafeArea(
        child: _map(),
      ),
    );
  }

  Widget _map() {
    final cameraPosition = CameraPosition(
      target: LatLng(
        6.328991566438365,
        -75.56795991544458,
      ),
      zoom: 15,
    );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: cameraPosition,
        ),
        BlocBuilder<PermissionsBloc, PermissionsState>(
          builder: (context, state) {
            if (state is RefreshPermissionStatus &&
                !state.model.locationPermissionEnabled) {
              return _noLocationPermissionGrantedWidget(context);
            }
            return SizedBox.shrink();
          },
        ),
        BlocBuilder<PermissionsBloc, PermissionsState>(
          builder: (context, state) {
            if (state is RefreshPermissionStatus && !state.model.gpsEnabled) {
              return _gpsNoEnabledWidget(context);
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _gpsNoEnabledWidget(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        color: Colors.red[400],
        child: Text(
          context.l10n.gpsDisable,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _noLocationPermissionGrantedWidget(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.locationPermissionsNeed),
            SizedBox(height: 5.0),
            MaterialButton(
              child: Text(context.l10n.enableAccess),
              color: Color(0xff2ed29e),
              textColor: Colors.white,
              shape: StadiumBorder(),
              onPressed: () => context
                  .read<PermissionsBloc>()
                  .add(OnRequestLocationPermission()),
            ),
          ],
        ),
      ),
    );
  }
}
