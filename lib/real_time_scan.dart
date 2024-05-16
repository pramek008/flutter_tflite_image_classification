import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'services/tensorflow_service.dart';

class RealTimeScanPage extends StatefulWidget {
  const RealTimeScanPage({super.key});

  @override
  State<RealTimeScanPage> createState() => _RealTimeScanPageState();
}

class _RealTimeScanPageState extends State<RealTimeScanPage> {
  List<CameraDescription> cameras = [];
  late CameraImage cameraImage;
  late CameraController cameraController;
  // late ScanBloc _scanBloc;
  String result = "";

  initCamera() async {
    try {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await cameraController.initialize();
      if (!mounted) return;
      setState(() {});
      cameraController.startImageStream((imageStream) {
        cameraImage = imageStream;
        // runModel();
        TfLiteService()
            .scanImageOnFrame(
                cameraImage.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                cameraImage.height,
                cameraImage.width)
            .then((value) {
          setState(() {
            result = value[0].label;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  // runModel() async {
  //   var recognitions = await Tflite.runModelOnFrame(
  //       bytesList: cameraImage.planes.map((plane) {
  //         return plane.bytes;
  //       }).toList(),
  //       imageHeight: cameraImage.height,
  //       imageWidth: cameraImage.width,
  //       imageMean: 127.5,
  //       imageStd: 127.5,
  //       rotation: 90,
  //       numResults: 2,
  //       threshold: 0.1,
  //       asynch: true);
  //   for (var element in recognitions!) {
  //     setState(() {
  //       result = element["label"];
  //       print(result);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initCamera();
    TfLiteService().loadModel();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Face Mask Detector"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: !cameraController.value.isInitialized
                    ? Container()
                    : AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      ),
              ),
            ),
            Text(
              result,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
