import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();
      // Use XNNPACK Delegate
      if (Platform.isAndroid) interpreterOptions.addDelegate(XNNPackDelegate());
      // Use Metal Delegate
      if (Platform.isIOS) interpreterOptions.addDelegate(GpuDelegate());

      _interpreter = await Interpreter.fromAsset('assets/tflite/model.tflite');
      setState(() {
        _isReady = true;
      });
      _processImage('assets/images/fruits.jpg');
    } on Exception catch (e) {
      debugPrint('Failed to load model: $e');
    }
  }

  Future<void> _loadLabels() async {
    final labels = await rootBundle.loadString('assets/tflite/labels.txt');
    _labels = labels.split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(child: Image.network('assets/images/fruits.jpg')),
      _isReady
          ? Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Placeholder(),
              ),
            )
          : Container()
    ]);
  }

  Future<void> _processImage(String path) async {
    try {
      final input = await File(path).readAsBytes();
      final output = [List<int>.filled(1001, 0)];
      _interpreter.run(input, output);

      final result = output.first;
      debugPrint('AI object detection result: $result');
    } on Exception catch (e) {
      debugPrint('Error: $e');
    }
  }
}
