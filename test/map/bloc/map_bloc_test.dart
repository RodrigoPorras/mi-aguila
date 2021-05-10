import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_aguila/map/bloc/map_bloc.dart';

void main() {
  group('MapBlocText', () {
    MapBloc mapBloc;

    setUp(() {
      mapBloc = MapBloc();
    });

    tearDown(() {
      mapBloc.close();
    });

    test('The initial state of the app must be <MapInitialState> ', () {
      expect(mapBloc.state, MapInitialState(Model()));
    });

    blocTest(
      "When OnMapReady event is trigger then mapReady value is set to true",
      build: () => mapBloc,
      act: (bloc) => bloc.add(OnMapReady()),
      expect: [RefreshMapState(Model(mapReady: true))],
    );
  });
}
