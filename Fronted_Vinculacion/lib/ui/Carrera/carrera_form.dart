import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Carrera/carrera_api.dart';
import 'package:vinculacion/modelo/CarreraModelo.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class CarreraFormScreen extends StatefulWidget {
  final CarreraDto? carrera;

  CarreraFormScreen({this.carrera});

  @override
  _CarreraFormScreenState createState() => _CarreraFormScreenState();
}

class _CarreraFormScreenState extends State<CarreraFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.carrera != null) {
      nombreController.text = widget.carrera!.nombreFacultad ?? '';
    }
  }

  Future<void> _saveCarrera() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final token = TokenUtil.TOKEN;
      if (token == null || token.isEmpty) {
        print("Error: Token is missing");
        return;
      }

      CarreraApi api = CarreraApi.create();
      CarreraDto carrera = CarreraDto(
        id: widget.carrera?.id,
        nombreFacultad: nombreController.text,
      );

      if (widget.carrera == null) {
        // If it's a new Carrera
        await api.saveCarrera(token, carrera);
      } else {
        // If editing an existing Carrera
        await api.updateCarrera(token, carrera);
      }

      Navigator.pop(context, true);
    } catch (error) {
      print("Error saving carrera: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving Carrera. Please try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carrera == null ? 'Agregar Carrera' : 'Editar Carrera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.carrera == null ? 'Crear Nueva Carrera' : 'Actualizar Carrera',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Facultad',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de facultad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveCarrera,
                  child: Text(
                    widget.carrera == null ? 'Guardar' : 'Actualizar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
