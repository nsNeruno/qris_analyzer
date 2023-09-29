part of '../../analyzer_bloc.dart';

abstract class AnalyzerEvent {
  const AnalyzerEvent();
}

class AnalyzerOnScan extends AnalyzerEvent {

  const AnalyzerOnScan(this.scannedData,);

  final String scannedData;
}

class AnalyzerOnPasted extends AnalyzerEvent {

  const AnalyzerOnPasted(this.pastedData,);

  final String pastedData;
}

class AnalyzerOnImageFile extends AnalyzerEvent {

  const AnalyzerOnImageFile(this.filePath,);

  final String filePath;
}