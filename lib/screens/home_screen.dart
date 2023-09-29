import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qris_analyzer/blocs/analyzer_bloc.dart';
import 'package:qris_analyzer/blocs/dashboard_bloc.dart';
import 'package:qris_analyzer/blocs/setting_bloc.dart';
import 'package:qris_analyzer/models/cached_code.dart';
import 'package:qris_analyzer/screens/routes.dart';
import 'package:qris_analyzer/utils/bottom_sheet.dart';
import 'package:qris_analyzer/widgets/code_entry.dart';

part 'home/dashboard_screen.dart';
part 'home/favorite_screen.dart';
part 'home/setting_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<SettingBloc>().add(
          const SettingLoadPermissions(),
        );
        final dbBloc = context.read<DashboardBloc>();
        dbBloc.add(
          const DashboardReloadSavedCodes(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<DashboardBloc, DashboardState>(
      listener: (_, state,) {
        final transient = state.transient;
        if (transient is CachedCode) {
          context.read<DashboardBloc>().add(
            const DashboardLoadFavorites(),
          );
        }
      },
      child: BlocListener<AnalyzerBloc, AnalyzerState>(
        listener: (_, state,) {
          if (state.error == null) {
            final qris = state.data;
            if (qris != null) {
              context.read<DashboardBloc>().add(
                const DashboardLoadHistories(),
              );
              Navigator.of(context,).pushNamed(AppRoutes.details,);
            }
          }
        },
        listenWhen: (_, state,) {
          return state.tag == 'pasted';
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('QRIS Analyzer',),
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _bNavIndex,
            builder: (_, index, __,) => BottomNavigationBar(
              currentIndex: index,
              onTap: (_) => _bNavIndex.value = _,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard,),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite,),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings,),
                  label: 'Settings',
                ),
              ],
            ),
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _bNavIndex,
            builder: (context, index, _,) {
              if (index != 0) {
                return const SizedBox.shrink();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'Raw',
                    tooltip: 'From Raw Code',
                    onPressed: () {
                      _showPasteCodeInput();
                    },
                    child: const Icon(Icons.keyboard_alt_outlined,),
                  ),
                  const RSizedBox(height: 12,),
                  FloatingActionButton(
                    heroTag: 'Scan',
                    tooltip: 'Scan Barcode',
                    onPressed: () {
                      final cameraPermission = context.read<SettingBloc>().state.cameraPermission;
                      if (cameraPermission?.isPermanentlyDenied ?? false) {
                        openAppSettings();
                      } else {
                        if (cameraPermission?.isGranted ?? false) {
                          Navigator.of(context,).pushNamed(
                            AppRoutes.scanner,
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.qr_code_scanner,),
                  ),
                ],
              );
            }
          ),
          body: ValueListenableBuilder(
            valueListenable: _bNavIndex,
            builder: (context, index, _,) {
              return IndexedStack(
                index: index,
                children: const [
                  _DashboardScreen(),
                  _FavoriteScreen(),
                  _SettingScreen(),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bNavIndex.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<SettingBloc>().add(
          const SettingLoadPermissions(),
        );
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _showPasteCodeInput() async {
    late final codeController = TextEditingController();
    showCustomModalBottomSheet<String>(
      context: context,
      heightRatio: 0.3,
      builder: (_) {
        return Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                onPressed: () {
                  Navigator.of(_,).pop();
                },
                icon: const Icon(Icons.close,),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Paste Code Here',
                  border: OutlineInputBorder(),
                ),
                controller: codeController,
                expands: true,
                minLines: null,
                maxLines: null,
              ),
            ),
            const RSizedBox(height: 12,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(_,).pop(codeController.text.trim(),);
              },
              child: const Text('Check',),
            ),
          ],
        );
      },
    ).then(
      (_) {
        if (_?.isNotEmpty ?? false) {
          context.read<AnalyzerBloc>().add(
            AnalyzerOnPasted(_!,),
          );
        }
        Future.delayed(
          const Duration(seconds: 1,),
          () {
            codeController.dispose();
          },
        );
      },
    );
  }

  late final _bNavIndex = ValueNotifier<int>(0,);
}