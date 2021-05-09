import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mi_aguila/l10n/l10n.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titleApp),
      ),
      body: Container(),
    );
  }
}
