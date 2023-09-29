import 'dart:convert';

import 'package:flutter/foundation.dart';

export 'dart:convert' show jsonEncode, jsonDecode;

abstract class Serializable {

  const Serializable();

  Map<String, dynamic> toMap([Object? args,]);

  String toJsonString({bool pretty = false,}) {
    if (pretty) {
      return const JsonEncoder.withIndent('\t',).convert(toMap(),);
    }
    return jsonEncode(toMap(),);
  }

  Future<String> toJsonStringAsync({bool pretty = false,}) async {
    String? json;
    final data = toMap();
    if (pretty) {
      json = await compute(_encodeJsonPretty, data,);
    } else {
      json = await compute(_encodeJson, data,);
    }
    if (json == null) {
      throw JsonUnsupportedObjectError(
        data,
      );
    }
    return json;
  }

  @override
  String toString() => toJsonString();
}

String? _encodeJson(Map<String, dynamic> data,) {
  try {
    return jsonEncode(data,);
  } catch (_) {
    return null;
  }
}

String? _encodeJsonPretty(Map<String, dynamic> data,) {
  try {
    return const JsonEncoder.withIndent('\t',).convert(data,);
  } catch (_) {
    return null;
  }
}