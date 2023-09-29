import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qris_analyzer/utils/os_checker.dart';

import 'src/base_state.dart';

export 'package:permission_handler/permission_handler.dart';

part 'src/events/setting.dart';
part 'src/states/setting.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {

  SettingBloc(): super(const SettingState._(),) {
    on<SettingLoadPermissions>(_onLoadPermissions,);
    on<SettingRequestCamera>(_onCameraPermissionRequest,);
    on<SettingRequestStorage>(_onStoragePermissionRequest,);
  }

  FutureOr<void> _onLoadPermissions(
    SettingLoadPermissions event, Emitter<SettingState> emit,
  ) async {
    if (Platform.isAndroid) {
      final checkResults = await Future.wait(
        [
          Permission.camera.status,
          if (await isAndroid13())
            Permission.photos.status
          else
            Permission.storage.status,
        ],
      );
      emit(
        state._copyWith(
          cameraPermission: checkResults[0],
          storagePermission: checkResults[1],
        ),
      );
    } else if (Platform.isIOS) {
      emit(
        state._copyWith(
          cameraPermission: PermissionStatus.granted,
          storagePermission: PermissionStatus.granted,
        ),
      );
    }
  }

  FutureOr<void> _onCameraPermissionRequest(
    SettingRequestCamera event, Emitter<SettingState> emit,
  ) async {
    if (Platform.isAndroid) {
      final cameraPermission = await Permission.camera.request();
      emit(
        state._copyWith(
          cameraPermission: cameraPermission,
        ),
      );
    } else if (Platform.isIOS) {
      emit(
        state._copyWith(cameraPermission: PermissionStatus.granted,),
      );
    }
  }

  FutureOr<void> _onStoragePermissionRequest(
    SettingRequestStorage event, Emitter<SettingState> emit,
  ) async {
    if (Platform.isAndroid) {
      final PermissionStatus status;
      if (await isAndroid13()) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
      emit(
        state._copyWith(
          storagePermission: status,
        ),
      );
    } else if (Platform.isIOS) {
      emit(
        state._copyWith(
          storagePermission: PermissionStatus.granted,
        ),
      );
    }
  }
}