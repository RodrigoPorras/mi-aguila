import 'package:flutter/material.dart';
import 'package:mi_aguila/map/view/map_page.dart';

final Map<String, Widget Function(BuildContext)> globalRoutes =
    <String, WidgetBuilder>{
  '/': (_) => MapPage(),
};
