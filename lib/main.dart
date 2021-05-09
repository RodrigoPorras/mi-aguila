import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:mi_aguila/app/app.dart';
import 'package:mi_aguila/app/app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  runZonedGuarded(
    () => runApp(const App()),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
