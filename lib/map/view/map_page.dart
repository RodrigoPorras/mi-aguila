import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mi_aguila/l10n/l10n.dart';
import 'package:mi_aguila/map/bloc/map_bloc.dart';
import 'package:mi_aguila/map/my_location/bloc/my_location_bloc.dart';
import 'package:mi_aguila/map/permissions/bloc/permissions_bloc.dart';
import 'package:mi_aguila/widgets/widgets.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  GlobalKey iconKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<MyLocationBloc>().startFollowing();

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
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return BtnStartMeasuring(
            icon: state.model.drawPathAndMeasure
                ? Icons.stop_circle_outlined
                : Icons.play_arrow_outlined,
            onPressed: () {
              final currentPos =
                  context.read<MyLocationBloc>().state.model.location;
              if (currentPos != null) {
                context.read<MapBloc>().moveCamera(currentPos);
              }
              context.read<MapBloc>().add(
                    state.model.drawPathAndMeasure
                        ? OnStopDrawPathAndMeasure()
                        : OnStartDrawPathAndMeasure(),
                  );
            },
          );
        },
      ),
    );
  }

  Widget _map() {
    var cameraPosition = CameraPosition(
      target: LatLng(4.667426, -74.056624),
      zoom: 16,
    );
    return Stack(
      children: [
        BlocBuilder<MyLocationBloc, MyLocationState>(
          builder: (context, state) {
            if (state is RefreshLocationState) {
              context.read<MapBloc>().moveCamera(state.model.location);
              if (context.read<MapBloc>().state.model.drawPathAndMeasure) {
                context.read<MapBloc>().add(
                    OnAddNewLine(pos: state.model.location, context: context));
              }
              cameraPosition = CameraPosition(
                target: state.model.location,
                zoom: 16,
              );
            }

            /* final currentPosMarker = Marker(
              markerId: MarkerId('current_pos'),
              position: state.model.location,
            ); */

            return GoogleMap(
              initialCameraPosition: cameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) =>
                  context.read<MapBloc>().initMapa(controller),
              polylines: context.read<MapBloc>().state.model.polyline != null
                  ? {context.read<MapBloc>().state.model.polyline}
                  : {},
              //markers: {currentPosMarker},
            );
          },
        ),
        /* BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is RefreshMapState && state.model.drawPathAndMeasure) {
              return Positioned(
                  top: state.model.screenPos.x,
                  left: state.model.screenPos.y,
                  child: CircleAvatar());
            }
            return Container();
          },
        ), */
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

  _getMarkerAsImage() async {
    RenderRepaintBoundary boundary = iconKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    var pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }

  Future<BitmapDescriptor> getCustomIcon(GlobalKey iconKey) async {
    Future<Uint8List> _capturePng(GlobalKey iconKey) async {
      try {
        print('inside');
        RenderRepaintBoundary boundary =
            iconKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        var pngBytes = byteData.buffer.asUint8List();
        print(pngBytes);
        return pngBytes;
      } catch (e) {
        print(e);
      }
    }

    Uint8List imageData = await _capturePng(iconKey);
    return BitmapDescriptor.fromBytes(imageData);
  }

  Widget _markerWidget() {
    return RepaintBoundary(
      key: iconKey,
      child: IconButton(
          icon: Icon(Icons.star),
          onPressed: () {
            // Do something
          }),
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
