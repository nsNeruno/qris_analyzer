part of '../../analyzer_bloc.dart';

class AnalyzerState extends BlocState {

  const AnalyzerState._({
    super.isLoading = false,
    super.error,
    super.tag,
    super.transient,
    this.scannedData,
    this.data,
  });

  AnalyzerState _copyWith({
    bool isLoading = false,
    Object? error,
    Object? tag,
    Object? transient,
    String? scannedData,
    QRIS? data,
  }) {
    return AnalyzerState._(
      isLoading: isLoading,
      error: error,
      tag: tag,
      transient: transient,
      scannedData: scannedData ?? this.scannedData,
      data: data ?? this.data,
    );
  }

  final String? scannedData;
  final QRIS? data;
}