import 'package:exam_face_mask_detection/bloc/scan_bloc.dart';
import 'package:exam_face_mask_detection/scan_page.dart';
import 'package:exam_face_mask_detection/services/image_picker_service.dart';
import 'package:exam_face_mask_detection/services/permission_service.dart';
import 'package:exam_face_mask_detection/services/tensorflow_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  GetIt.I.registerSingleton<PermissionService>(PermissionServiceImpl());
  GetIt.I.registerSingleton<ImagePickerServices>(ImagePickerServices());
  GetIt.I.registerSingleton<TfLiteService>(TfLiteService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScanBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Face Mask Detection',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ScanPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
