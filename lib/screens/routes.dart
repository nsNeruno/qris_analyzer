import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:qris_analyzer/screens/details_screen.dart';
import 'package:qris_analyzer/screens/home_screen.dart';
import 'package:qris_analyzer/screens/scanner_screen.dart';

class AppRoutes extends MapBase<String, WidgetBuilder> {

  AppRoutes();

  @override
  WidgetBuilder? operator [](Object? key) {
    return _internal[key];
  }

  @override
  void operator []=(String key, WidgetBuilder value) {
    // No-op
  }

  @override
  void clear() {
    // No-op
  }

  @override
  Iterable<String> get keys => _internal.keys;

  @override
  WidgetBuilder? remove(Object? key) {
    // No-op
    return null;
  }

  final _internal = <String, WidgetBuilder>{
    home: (_) => const HomeScreen(),
    scanner: (_) => const ScannerScreen(),
    details: (_) => const DetailsScreen(),
  };

  static const home = '/';
  static const scanner = '/scan';
  static const details = '/details';
}