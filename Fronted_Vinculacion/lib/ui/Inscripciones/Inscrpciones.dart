import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Inscripciones/inscripciones_api.dart';
import 'package:vinculacion/modelo/InscripcionesModelo.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class InscripcionesScreen extends StatefulWidget {
  @override
  _InscripcionesScreenState createState() => _InscripcionesScreenState();
}

class _InscripcionesScreenState extends State<InscripcionesScreen> {
  late InscripcionesApi inscripcionesApi;
  late List<InscripcionModelo> inscripcionesList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    inscripcionesApi = InscripcionesApi.create();
    _loadInscripciones();
  }

  Future<void> _loadInscripciones() async {
    setState(() => _isLoading = true);
    try {
      final token = TokenUtil.TOKEN;
      if (token == null || token.isEmpty) {
        print("Error: Token no válido o ausente");
        return;
      }

      final data = await inscripcionesApi.listarInscripciones(token);
      setState(() {
        inscripcionesList = data;
      });
    } catch (error) {
      print("Error al cargar inscripciones: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Inscripciones"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: inscripcionesList.length,
        itemBuilder: (context, index) {
          final inscripcion = inscripcionesList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              title: Text("Evento: ${inscripcion.evento.nombreDelEvento}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Usuario: ${inscripcion.usuario.nombres}"),
                  Text("Estado: ${inscripcion.estado}"),
                  Text("Horas Asignadas: ${inscripcion.horasAsignadas}"),
                  Text("Fecha Inscripción: ${inscripcion.fechaInscripcion}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
