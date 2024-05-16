part of 'scan_bloc.dart';

@immutable
sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends ScanEvent {}

class TakeImageEvent extends ScanEvent {}

class ScanImageEvent extends ScanEvent {
  final File image;

  const ScanImageEvent({required this.image});

  @override
  List<Object> get props => [image];
}
