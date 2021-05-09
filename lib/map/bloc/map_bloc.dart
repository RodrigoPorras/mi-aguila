import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitialState(Model()));

  GoogleMapController _googleMapController;

  void initMapa(GoogleMapController controller) {
    if (!state.model.mapReady) {
      this._googleMapController = controller;
      add(OnMapReady());
    }
  }

  void moveCamera(LatLng position) {
    final cameraUpdate = CameraUpdate.newLatLng(position);
    this._googleMapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is OnMapReady) {
      yield* _onMapReady(event);
    } else if (event is OnStartDrawPathAndMeasure) {
      yield* _onStartDrawPathAndMeasure(event);
    } else if (event is OnAddNewLine) {
      yield* _onAddNewLine(event);
    } else if (event is OnStopDrawPathAndMeasure) {
      yield* _onStopDrawPathAndMeasure(event);
    }
  }

  Stream<MapState> _onStopDrawPathAndMeasure(
      OnStopDrawPathAndMeasure envent) async* {
    yield RefreshMapState(state.model.copyWith(drawPathAndMeasure: false));
  }

  Stream<MapState> _onStartDrawPathAndMeasure(
      OnStartDrawPathAndMeasure envent) async* {
    final polyline = Polyline(
      polylineId: PolylineId('poli'),
      patterns: [
        PatternItem.dot,
        PatternItem.gap(20),
      ],
      color: Color(0xff2ed29e),
      points: [],
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      width: 12,
    );

    yield RefreshMapState(
        state.model.copyWith(drawPathAndMeasure: true, polyline: polyline));
  }

  Stream<MapState> _onMapReady(OnMapReady envent) async* {
    yield RefreshMapState(state.model.copyWith(mapReady: true));
  }

  Stream<MapState> _onAddNewLine(OnAddNewLine event) async* {
    var points = [...state.model.polyline.points, event.pos];

    /* final coordinate = await _googleMapController.getScreenCoordinate(
      event.pos,
    );
    final ratio = MediaQuery.of(event.context).devicePixelRatio;

    var _x = coordinate.x.toDouble() / ratio;
    var _y = coordinate.y.toDouble() / ratio; */

    yield RefreshMapState(
      state.model.copyWith(
        polyline: state.model.polyline.copyWith(pointsParam: points),
        // screenPos: ScreenPosition(x: _x, y: _y),
      ),
    );
  }
}
