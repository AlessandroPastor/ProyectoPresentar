import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class SimpleImageCaptureScreen extends StatefulWidget {
  @override
  _SimpleImageCaptureScreenState createState() =>
      _SimpleImageCaptureScreenState();
}

class _SimpleImageCaptureScreenState extends State<SimpleImageCaptureScreen> {
  File? _selectedImage;
  String? _results;
  Interpreter? _interpreter;
  List<String>? _labels;

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('model_unquant.tflite');
      print("Modelo cargado correctamente.");

      final labelsData = await rootBundle.loadString('assets/labels.txt');
      if (labelsData.isEmpty) {
        print("Error: El archivo de etiquetas está vacío.");
        return;
      }

      setState(() {
        _labels = labelsData.split('\n');
      });
      print("Etiquetas cargadas correctamente: $_labels");
    } catch (e) {
      print("Error al cargar el modelo o etiquetas: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _results = null;
      });
      await _runInference(File(pickedFile.path));
    } else {
      print("No se seleccionó ninguna imagen.");
    }
  }

  Future<void> _captureImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _results = null;
      });
      await _runInference(File(pickedFile.path));
    } else {
      print("No se capturó ninguna imagen válida.");
    }
  }

  Future<void> _runInference(File imageFile) async {
    try {
      final rawImage = imageFile.readAsBytesSync();
      final decodedImage = await decodeImageFromList(rawImage);

      if (_interpreter == null) {
        print("Error: El modelo no se ha cargado correctamente.");
        return;
      }

      final inputShape = _interpreter!.getInputTensor(0).shape;
      final imageProcessor = ImageProcessorBuilder()
          .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
          .add(NormalizeOp(0, 255))
          .build();

      var tensorImage = TensorImage.fromFile(imageFile);
      tensorImage = imageProcessor.process(tensorImage);

      final outputBuffer =
      TensorBuffer.createFixedSize([_labels!.length], TfLiteType.float32);
      _interpreter!.run(tensorImage.buffer, outputBuffer.buffer);

      final probabilities = outputBuffer.getDoubleList();
      final sortedResults = probabilities.asMap().entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topResults = sortedResults.take(3).map((entry) {
        return '${_labels![entry.key]}: ${(entry.value * 100).toStringAsFixed(2)}%';
      }).toList();

      setState(() {
        _results = topResults.join('\n');
      });
    } catch (e) {
      print("Error al procesar la imagen: $e");
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Escaner de Objetos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Esto centra el título
        backgroundColor: Colors.deepPurple,
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _selectedImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Text(
                  "Selecciona o captura una imagen",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_results != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Resultados:\n$_results',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.photo_library),
                  label: Text("Galería"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _captureImageFromCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text("Cámara"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
