import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:exam_face_mask_detection/model/response_detection_model.dart';
import 'package:exam_face_mask_detection/services/tensorflow_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../services/image_picker_service.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(InitialScanState()) {
    final TfLiteService tfLiteService = GetIt.I.get<TfLiteService>();
    tfLiteService.loadModel();

    on<ScanEvent>((event, emit) {});

    on<PickImageEvent>((event, emit) async {
      emit(ImagePickedLoadingState());
      final image = GetIt.I.get<ImagePickerServices>();
      final File imageFile = await image.pickImage();
      emit(ImagePickedState(image: imageFile));
    });

    on<TakeImageEvent>((event, emit) async {
      emit(ImagePickedLoadingState());
      final image = GetIt.I.get<ImagePickerServices>();
      final File imageFile = await image.takeImage();
      emit(ImagePickedState(image: imageFile));
    });

    on<ScanImageEvent>((event, emit) async {
      emit(ScanLoadingState());
      final classify = GetIt.I.get<TfLiteService>();
      emit(ScanLoadingState());
      final List<TfLiteModel> scanResult =
          await classify.scanImage(event.image);
      emit(ScanResultState(scanResult: scanResult, image: event.image));
    });
  }
}
