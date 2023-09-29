import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void debugLog(Object? message, {String? name,}) {
  if (kDebugMode) {
    scheduleMicrotask(
      () {
        log('$message', name: name ?? '',);
      },
    );
  }
}

void jsonLog(Map<String, dynamic> Function() builder, {String? name,}) {
  debugLog(
    jsonEncode(builder(),),
    name: name,
  );
}

void debugErrorLog(dynamic error, {String? name,}) {
  try {
    if (kDebugMode) {
      print(error.stackTrace,);
    }
  } catch (_) {}
  debugLog(error, name: name,);
}