import 'package:ai_object_detector/tflite/object_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagePicker = ImagePicker();

  ObjectDetection? objectDetection;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    objectDetection = ObjectDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Placeholder(),
        ),
        Positioned(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      image = objectDetection!.processImage(result.path);
                      setState(() {});
                    }
                  },
                  icon: const Icon(
                    Icons.photo,
                    size: 64,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
