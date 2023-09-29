part of '../home_screen.dart';

class _SettingScreen extends StatelessWidget {

  const _SettingScreen();

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      itemBuilder: (_, i,) {
        switch (i) {
          case 0:
            return const _CameraPermissionSetting();
          case 1:
            return const _StoragePermissionSetting();
        }
        return const SizedBox.shrink();
      },
      separatorBuilder: (_, __,) => const Divider(
        height: 1,
        thickness: 1,
      ),
      itemCount: 2,
    );
  }
}

class _CameraPermissionSetting extends StatelessWidget {

  const _CameraPermissionSetting();

  @override
  Widget build(BuildContext context) {

    return BlocSelector<SettingBloc, SettingState, PermissionStatus?>(
      selector: (state,) => state.cameraPermission,
      builder: (_, cameraPermission,) {
        final hasPermission = cameraPermission?.isGranted ?? false;
        return ListTile(
          leading: const Icon(Icons.camera,),
          title: const Text('Camera Permission',),
          trailing: TextButton(
            onPressed: hasPermission ? null : () {
              if (cameraPermission?.isPermanentlyDenied ?? false) {
                openAppSettings();
              } else {
                context.read<SettingBloc>().add(
                  const SettingRequestCamera(),
                );
              }
            },
            child: Text(hasPermission ? 'Granted' : 'Request',),
          ),
        );
      },
    );
  }
}

class _StoragePermissionSetting extends StatelessWidget {

  const _StoragePermissionSetting();

  @override
  Widget build(BuildContext context) {

    return BlocSelector<SettingBloc, SettingState, PermissionStatus?>(
      selector: (state,) => state.storagePermission,
      builder: (_, storagePermission,) {
        final hasPermission = storagePermission?.isGranted ?? false;
        return ListTile(
          leading: const Icon(Icons.storage,),
          title: const Text('Storage Permission',),
          trailing: TextButton(
            onPressed: hasPermission ? null : () {
              if (storagePermission?.isPermanentlyDenied ?? false) {
                openAppSettings();
              } else {
                context.read<SettingBloc>().add(
                  const SettingRequestStorage(),
                );
              }
            },
            child: Text(hasPermission ? 'Granted' : 'Request',),
          ),
        );
      },
    );
  }
}