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
          case 2:
            return const _ClearRecentEntries();
          case 3:
            return const _ClearFavorites();
        }
        return const SizedBox.shrink();
      },
      separatorBuilder: (_, __,) => const Divider(
        height: 1,
        thickness: 1,
      ),
      itemCount: 4,
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

class _ClearRecentEntries extends StatelessWidget {

  const _ClearRecentEntries();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        _confirm(context,).then(
          (_) {
            if (_) {
              context.read<DashboardBloc>().add(
                const DashboardClearRecentEntries(),
              );
            }
          },
        );
      },
      child: const ListTile(
        leading: Icon(Icons.access_time,),
        title: Text('Clear Recents',),
        trailing: Icon(Icons.chevron_right,),
      ),
    );
  }

  Future<bool> _confirm(BuildContext context,) {
    return showCustomModalBottomSheet<bool>(
      context: context,
      heightRatio: 0.2,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clear Recent Codes?',
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            const Spacer(),
            const Text('This action cannot be undone',),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(_,).pop(true,);
                    },
                    child: const Text('Clear',),
                  ),
                ),
                const RSizedBox(width: 8,),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(_,).pop(false,);
                    },
                    child: const Text('Cancel',),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((_) => _ ?? false,);
  }
}

class _ClearFavorites extends StatelessWidget {

  const _ClearFavorites();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        _confirm(context,).then(
          (_) {
            if (_) {
              context.read<DashboardBloc>().add(
                const DashboardClearFavorites(),
              );
            }
          },
        );
      },
      child: const ListTile(
        leading: Icon(Icons.star_border,),
        title: Text('Clear Favorites',),
        trailing: Icon(Icons.chevron_right,),
      ),
    );
  }

  Future<bool> _confirm(BuildContext context,) {
    return showCustomModalBottomSheet<bool>(
      context: context,
      heightRatio: 0.2,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clear Favorite Codes?',
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            const Spacer(),
            const Text('This action cannot be undone',),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(_,).pop(true,);
                  },
                  child: const Text('Clear',),
                ),
                const RSizedBox(width: 8,),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(_,).pop(false,);
                  },
                  child: const Text('Cancel',),
                ),
              ],
            ),
          ],
        );
      },
    ).then((_) => _ ?? false,);
  }
}