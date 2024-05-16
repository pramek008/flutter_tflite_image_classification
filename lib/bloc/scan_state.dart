part of 'scan_bloc.dart';

@immutable
sealed class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

final class InitialScanState extends ScanState {}

final class ImagePickedLoadingState extends ScanState {}

final class ImagePickedState extends ScanState {
  final File image;

  const ImagePickedState({required this.image});

  @override
  List<Object> get props => [image];
}

final class ImagePickedErrorState extends ScanState {}

final class ScanLoadingState extends ScanState {}

final class ScanResultState extends ScanState {
  final File image;
  final List<TfLiteModel> scanResult;

  const ScanResultState({required this.image, required this.scanResult});

  @override
  List<Object> get props => [scanResult];
}
