import 'dart:async';

import 'package:barcode_scanner_kit/barcode_scanner_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qris/qris.dart';
import 'package:qris_analyzer/data/src/pref_storage.dart';
import 'package:qris_analyzer/models/cached_code.dart';

import 'src/base_state.dart';

part 'src/events/analyzer.dart';
part 'src/states/analyzer.dart';

class AnalyzerBloc extends Bloc<AnalyzerEvent, AnalyzerState> {
  AnalyzerBloc(
    PrefListStorage<CachedCode> cacheRepository,
  ): _cacheRepository = cacheRepository, super(const AnalyzerState._(),) {

    on<AnalyzerOnScan>(_onScan,);
    on<AnalyzerOnImageFile>(_onImageFile,);
    on<AnalyzerOnPasted>(_onPasted,);
  }

  Future<void> _onScan(
    AnalyzerOnScan event, Emitter<AnalyzerState> emit,
  ) async {
    try {
      final qris = QRIS(event.scannedData,);
      emit(
        state._copyWith(
          scannedData: event.scannedData,
          data: qris,
        ),
      );
      _cacheRepository.add(
        CachedCode(
          merchantName: qris.merchantName,
          data: event.scannedData,
          createdAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(
        state._copyWith(
          error: _,
        ),
      );
    }
  }

  FutureOr<void> _onImageFile(
    AnalyzerOnImageFile event, Emitter<AnalyzerState> emit,
  ) async {
    try {
      final barcodesList = await BarcodeScanner(
        formats: [BarcodeFormat.qrCode,],
      ).processImage(
        InputImage.fromFilePath(event.filePath,),
      );
      if (barcodesList.isNotEmpty) {
        for (final barcode in barcodesList) {
          try {
            final scannedData = barcode.value.rawValue!;
            final qris = QRIS(scannedData,);
            emit(
              state._copyWith(
                scannedData: scannedData,
                data: qris,
              ),
            );
            break;
          } catch (_) {
            continue;
          }
        }
      }
    } catch (_) {
      emit(
        state._copyWith(
          error: _,
          transient: event.filePath,
        ),
      );
    }
  }

  FutureOr<void> _onPasted(
    AnalyzerOnPasted event, Emitter<AnalyzerState> emit,
  ) async {
    try {
      final qris = QRIS(event.pastedData,);
      emit(
        state._copyWith(
          scannedData: event.pastedData,
          data: qris,
          tag: 'pasted',
        ),
      );
    } catch (_) {
      emit(
        state._copyWith(
          error: _,
          tag: 'pasted',
        ),
      );
    }
  }

  final PrefListStorage<CachedCode> _cacheRepository;
}