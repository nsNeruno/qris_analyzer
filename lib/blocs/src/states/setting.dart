part of '../../setting_bloc.dart';

class SettingState extends BlocState {

  const SettingState._({
    super.isLoading = false,
    super.error,
    super.tag,
    super.transient,
    this.cameraPermission,
    this.storagePermission,
  });

  SettingState _copyWith({
    bool isLoading = false,
    Object? error,
    Object? tag,
    Object? transient,
    PermissionStatus? cameraPermission,
    PermissionStatus? storagePermission,
  }) {
    return SettingState._(
      isLoading: isLoading,
      error: error,
      tag: tag,
      transient: transient,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      storagePermission: storagePermission ?? this.storagePermission,
    );
  }

  final PermissionStatus? cameraPermission;
  final PermissionStatus? storagePermission;
}