import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qris_analyzer/blocs/analyzer_bloc.dart';
import 'package:qris_analyzer/blocs/dashboard_bloc.dart';
import 'package:qris_analyzer/blocs/setting_bloc.dart';
import 'package:qris_analyzer/screens/routes.dart';
import 'package:qris_analyzer/utils/os_checker.dart';

class ScannerScreen extends StatefulWidget {

  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<SettingBloc>().add(
          const SettingLoadPermissions(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final bloc = context.read<AnalyzerBloc>();
    final settings = context.read<SettingBloc>();

    return BlocListener<AnalyzerBloc, AnalyzerState>(
      listener: (context, state,) {
        if (state.error == null) {
          final qris = state.data;
          if (qris != null) {
            context.read<DashboardBloc>().add(
              const DashboardLoadHistories(),
            );
            Navigator.of(context,).pushReplacementNamed(
              AppRoutes.details,
            );
            return;
          }
        }
        scannerController.start();
      },
      child: Scaffold(
        body: BlocSelector<SettingBloc, SettingState, bool>(
          selector: (state,) {
            return state.cameraPermission?.isGranted ?? false;
          },
          builder: (context, cameraAllowed,) {

            if (!cameraAllowed) {
              return Column(
                children: [
                  const Text(
                    'Camera Permission is Required',
                    textAlign: TextAlign.center,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      settings.add(
                        const SettingRequestCamera(),
                      );
                    },
                    child: const Text(
                      'Request Camera Permission',
                    ),
                  ),
                ],
              );
            }

            return Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: (barcodeCapture,) {
                    final barcodes = barcodeCapture.barcodes;
                    if (barcodes.isNotEmpty) {
                      scannerController.stop();
                      bloc.add(
                        AnalyzerOnScan(
                          barcodes.first.rawValue!,
                        ),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        final storagePermission = settings.state.storagePermission;
                        switch (storagePermission) {
                          case PermissionStatus.denied:
                          case null:
                            settings.add(
                              const SettingRequestStorage(),
                            );
                            break;
                          case PermissionStatus.restricted:
                          case PermissionStatus.permanentlyDenied:
                            openAppSettings();
                            break;
                          case PermissionStatus.granted:
                          case PermissionStatus.limited:
                          case PermissionStatus.provisional:
                            _selectImage();
                            break;
                        }
                      },
                      icon: const Icon(
                        Icons.image_outlined,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: scannerController.torchState,
                      builder: (context, torchState, _,) {
                        return IconButton(
                          onPressed: () {
                            scannerController.toggleTorch();
                          },
                          icon: Icon(
                            torchState == TorchState.on
                                ? Icons.flash_off
                                : Icons.flash_on,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    scannerController.stop();
    scannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) {
      return;
    }
    switch (state) {
      case AppLifecycleState.resumed:
        scannerController.start();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        scannerController.stop();
        break;
    }
  }

  Future<void> _selectImage() async {
    XFile? xFile;
    try {
      scannerController.stop();
      if (await isAndroid13()) {
        final imagePicker = (ImagePicker() as ImagePickerAndroid)
          ..useAndroidPhotoPicker = true;
        xFile = await imagePicker.getImageFromSource(
          source: ImageSource.gallery,
        );
      } else {
        xFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
      }
    } catch (_) {

    } finally {
      scannerController.start();
    }
    final path = xFile?.path;
    if (path != null && mounted) {
      context.read<AnalyzerBloc>().add(
        AnalyzerOnImageFile(path,),
      );
    }
  }

  late final scannerController = MobileScannerController(
    formats: [
      BarcodeFormat.qrCode,
    ],
  );
}