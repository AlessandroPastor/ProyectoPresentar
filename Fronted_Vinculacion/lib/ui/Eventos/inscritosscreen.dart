import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Evento/evento_api.dart';
import 'package:vinculacion/apis/Inscripciones/inscripciones_api.dart';
import 'package:vinculacion/modelo/Inscripciones.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class ListaInscritosScreen extends StatefulWidget {
  final int eventoId;

  ListaInscritosScreen({required this.eventoId});

  @override
  _ListaInscritosScreenState createState() => _ListaInscritosScreenState();
}

class _ListaInscritosScreenState extends State<ListaInscritosScreen> {
  late EventoApi apiService;
  late InscripcionesApi inscripcionesApi;
  EventoDto? evento;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = EventoApi.create();
    inscripcionesApi = InscripcionesApi.create();
    _fetchEventoConInscripciones();
  }

  Future<void> _fetchEventoConInscripciones() async {
    try {
      final token = TokenUtil.TOKEN;
      if (token == null || token.isEmpty) {
        print("Error: El token no está disponible.");
        return;
      }
      final data = await apiService.getEventoConInscripciones(token, widget.eventoId);
      setState(() {
        evento = data;
        _isLoading = false;
      });
    } catch (error) {
      print("Error al obtener inscripciones: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _eliminarInscripcion(int inscripcionId, int index) async {
    try {
      final token = TokenUtil.TOKEN;
      await inscripcionesApi.eliminarInscripcion(token, inscripcionId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inscripción eliminada con éxito")),
      );

      setState(() {
        evento?.inscripciones.removeAt(index);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar inscripción: $error")),
      );
    }
  }

  Future<void> _editarHoras(int inscripcionId, int index) async {
    int? horasEditadas = await showDialog(
      context: context,
      builder: (context) {
        int? newHoras;
        return AlertDialog(
          title: Text("Editar Horas"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Ingrese las horas editadas"),
            onChanged: (value) {
              newHoras = int.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, newHoras),
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (horasEditadas != null) {
      try {
        final token = TokenUtil.TOKEN;
        await inscripcionesApi.editarHoras(token, inscripcionId, horasEditadas);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Horas editadas con éxito")),
        );

        setState(() {
          evento?.inscripciones[index].horasEditadas = horasEditadas;
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al editar horas: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Detalles del Evento'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : evento == null
          ? Center(child: Text("No se encontraron inscritos."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evento: ${evento?.nombreDelEvento ?? ''}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Dirección: ${evento?.direccionLugar ?? 'No disponible'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Divider(thickness: 1.5, color: Colors.grey[400]),
            SizedBox(height: 8),
            Text(
              'Inscritos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: evento!.inscripciones.length,
                itemBuilder: (context, index) {
                  final inscripcion = evento!.inscripciones[index];
                  final usuarioInfo = inscripcion.usuarioinfo.isNotEmpty
                      ? inscripcion.usuarioinfo.first
                      : null;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        usuarioInfo?.nombres ?? "Nombre no disponible",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apellidos: ${usuarioInfo?.apellidos ?? "No disponible"}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Código: ${usuarioInfo?.codigo ?? "No disponible"}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Horas Editadas: ${inscripcion.horasEditadas ?? "No asignadas"}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              _editarHoras(inscripcion.id, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              _eliminarInscripcion(inscripcion.id, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
