// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:exam_face_mask_detection/model/response_detection_model.dart';
import 'package:tflite/tflite.dart';

class TfLiteService {
  static final TfLiteService _instance = TfLiteService._internal();
  factory TfLiteService() => _instance;
  TfLiteService._internal();

  //dispose
  void dispose() {
    Tflite.close();
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/face_models.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<List<TfLiteModel>> scanImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    print("recognitions: $recognitions");
    List<TfLiteModel> model = recognitions!
        .map((e) => TfLiteModel(
              confidence: e['confidence'],
              index: e['index'],
              label: e['label'],
            ))
        .toList();
    print('model Comfidence: ${model[0].confidence}');
    print('model Index: ${model[0].index}');
    print('model Label: ${model[0].label}');
    return model;
  }

  Future<List<TfLiteModel>> scanImageOnFrame(
      List<Uint8List> bytesList, int imageHeight, int imageWidth) async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: bytesList,
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );
    print("recognitions: $recognitions");
    List<TfLiteModel> model = recognitions!
        .map((e) => TfLiteModel(
              confidence: e['confidence'],
              index: e['index'],
              label: e['label'],
            ))
        .toList();
    print('model Comfidence: ${model[0].confidence}');
    print('model Index: ${model[0].index}');
    print('model Label: ${model[0].label}');

    return model;
  }
}
