import 'dart:io';

import 'package:exam_face_mask_detection/bloc/scan_bloc.dart';
import 'package:exam_face_mask_detection/real_time_scan.dart';
import 'package:exam_face_mask_detection/services/tensorflow_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';

import 'model/response_detection_model.dart';
import 'utils/alert_dialog_util.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late final ScanBloc _scanBloc;

  @override
  void initState() {
    _scanBloc = ScanBloc();
    TfLiteService().loadModel();
    super.initState();
  }

  @override
  void dispose() {
    _scanBloc.close();
    TfLiteService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Mask Detection'),
      ),
      body: BlocBuilder<ScanBloc, ScanState>(
        bloc: _scanBloc,
        builder: (context, state) {
          print('state: $state');
          if (state is InitialScanState) {
            return buildInitialUI();
          } else if (state is ImagePickedState) {
            return buildImagePickedUI(state.image);
          } else if (state is ScanResultState) {
            return buildScanResultUI(state.image, state.scanResult);
          } else if (state is ScanLoadingState ||
              state is ImagePickedLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildInitialUI();
          }
        },
      ),
    );
  }

  Widget buildInitialUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            // onPressed: () => _scanBloc.add(TakeImageEvent()),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RealTimeScanPage()));
            },
            child: const Text('Take Image'),
          ),
          ElevatedButton(
            onPressed: () => _scanBloc.add(PickImageEvent()),
            child: const Text('Select Image'),
          ),
        ],
      ),
    );
  }

  Widget buildImagePickedUI(File image) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: Image.file(image),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _scanBloc.add(ScanImageEvent(image: image)),
            child: const Text('Scan Image'),
          ),
        ],
      ),
    );
  }

  Widget buildScanResultUI(File image, List<TfLiteModel> scanResults) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            scanResults[0].label,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: scanResults[0].label == 'Masked'
                    ? Colors.green
                    : Colors.red),
          ),
          Text(
            'Confidence: ${scanResults[0].confidence.toStringAsFixed(3)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          buildInitialUI()
        ],
      ),
    );
  }

  void showPermissionDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        onConfirm: () => openAppSettings(),
        title: '$permissionType Permission',
        subtitle: 'This app needs $permissionType access to take pictures',
      ),
    );
  }

  //?################################################################
  // File? _image;
  // late List _scanResults;
  // bool imageSelected = false;

  // @override
  // void initState() {
  //   super.initState();
  //   loadModel();
  // }

  // Future loadModel() async {
  //   Tflite.close();
  //   await Tflite.loadModel(
  //     model: 'assets/face_models.tflite',
  //     labels: 'assets/labels.txt',
  //   );
  // }

  // Future scanImage(File image) async {
  //   var recognitions = await Tflite.runModelOnImage(
  //     path: image.path,
  //     imageMean: 0.0,
  //     imageStd: 255.0,
  //     numResults: 2,
  //     threshold: 0.2,
  //     asynch: true,
  //   );
  //   print("recognitions: $recognitions");
  //   // TfLiteModel model = TfLiteModel(
  //   //   confidence: recognitions![0]['confidence'],
  //   //   index: recognitions[0]['index'],
  //   //   label: recognitions[0]['label'],
  //   // );
  //   // print('model: ${model.confidence}');
  //   // print('model: ${model.index}');
  //   // print('model: ${model.label}');

  //   setState(() {
  //     _scanResults = recognitions!;
  //     _image = image;
  //     imageSelected = true;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //       title: const Text('Face Mask Detection'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           imageSelected
  //               ? Container(
  //                   height: 300,
  //                   width: 300,
  //                   decoration: BoxDecoration(
  //                     image: DecorationImage(
  //                       image: FileImage(_image!),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 )
  //               : Container(
  //                   height: 300,
  //                   width: 300,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[200],
  //                   ),
  //                 ),
  //           const SizedBox(height: 20),
  //           imageSelected
  //               ? _scanResults.isNotEmpty
  //                   ? Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Text(
  //                           '${_scanResults[0]['label']}',
  //                           style: Theme.of(context).textTheme.headlineMedium,
  //                         ),
  //                         Text(
  //                           'Confidence: ${_scanResults[0]['confidence'].toStringAsFixed(3)}',
  //                           style: Theme.of(context).textTheme.headlineSmall,
  //                         ),
  //                       ],
  //                     )
  //                   : const Text('No face detected')
  //               : const Text('No image selected'),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: () {
  //               pickImage();
  //             },
  //             child: const Text('Select Image'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Future pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //   File imageFile = File(image.path);
  //   scanImage(imageFile);
  // }
}
