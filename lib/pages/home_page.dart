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

  ObjectDetection? _objectDetection;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _objectDetection = ObjectDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Theme.of(context).secondaryHeaderColor,
            child:
                (_imageData != null) ? Image.memory(_imageData!) : Container(),
          ),
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
                    final selectedImage = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (selectedImage != null) {
                      _imageData = _objectDetection!.processImage(
                        selectedImage.path,
                      );
                      setState(() {});
                    }
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.white,
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
