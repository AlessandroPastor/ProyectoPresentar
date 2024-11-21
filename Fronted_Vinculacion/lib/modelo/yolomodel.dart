/*import 'package:tflite_flutter/tflite_flutter.dart';

class YoloModel {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('yolov5.tflite');
  }

  List<dynamic> runModel(List<dynamic> input) {
    var output = List.filled(1 * 25200 * 85, 0).reshape([1, 25200, 85]);
    _interpreter?.run(input, output);
    return output;
  }
}*/
