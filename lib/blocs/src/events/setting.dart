part of '../../setting_bloc.dart';

abstract class SettingEvent {
  const SettingEvent();
}

class SettingLoadPermissions extends SettingEvent {
  const SettingLoadPermissions();
}

class SettingRequestCamera extends SettingEvent {
  const SettingRequestCamera();
}

class SettingRequestStorage extends SettingEvent {
  const SettingRequestStorage();
}