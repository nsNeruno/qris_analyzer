import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isAndroid13() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 13;
  }
  return false;
}