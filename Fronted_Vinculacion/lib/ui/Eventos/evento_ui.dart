import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinculacion/apis/Evento/evento_api.dart';
import 'package:vinculacion/apis/Inscripciones/inscripciones_api.dart';
import 'package:vinculacion/modelo/EventoModelo.dart';
import 'package:vinculacion/ui/Eventos/eventofinalizados.dart';
import 'package:vinculacion/ui/Eventos/inscritosscreen.dart';
import 'package:vinculacion/util/TokenUtil.dart';
import 'edit_creareventos.dart';

class EventoUI extends StatefulWidget {
  @override
  _EventoUIState createState() => _EventoUIState();
}

class _EventoUIState extends State<EventoUI> {
  late EventoApi apiService;
  late InscripcionesApi inscripcionesApi;
  late List<EventoModelo> eventosList = [];
  bool _isLoading = false;
  bool showObservation = false;
  int? selectedEventoId;
  Map<int, bool> userInscripcionesStatus = {};
  String? userRole;

  @override
  void initState() {
    super.initState();
    apiService = EventoApi.create();
    inscripcionesApi = InscripcionesApi.create();
    _checkUserRole();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getUserRole();
    await _loadData();
  }

  void _checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("userRol");

    setState(() {
      userRole = role == "RolNombre.ROLE_ADMIN" ? "ROLE_ADMIN" : "USER";
    });

    print("Rol del usuario cargado: $userRole");
  }


  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString("userRol") ?? "Usuario sin Rol";

    setState(() {
      userRole = role;
    });

    print("Rol del usuario cargado: $userRole");
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      var data = await Provider.of<EventoApi>(context, listen: false).list(TokenUtil.TOKEN);
      setState(() {
        eventosList = data.where((evento) => evento.status == "Activo").toList();
      });
      await _checkUserInscriptionStatus();
    } catch (error) {
      print("Error al cargar eventos: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkUserInscriptionStatus() async {
    try {
      final token = TokenUtil.TOKEN;
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt("usuarioId");

      if (token == null || token.isEmpty || usuarioId == null) {
        print("Error: Token o usuarioId no válidos o ausentes");
        return;
      }

      for (var evento in eventosList) {
        bool isRegistered = await inscripcionesApi.checkUserRegistration(token, usuarioId, evento.id);
        setState(() {
          userInscripcionesStatus[evento.id] = isRegistered;
        });
      }
    } catch (error) {
      print("Error al verificar estado de inscripción: $error");
    }
  }

  Future<void> _inscribirseEnEvento(int eventoId) async {
    try {
      final token = TokenUtil.TOKEN;
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt("usuarioId");

      if (token == null || token.isEmpty || usuarioId == null) {
        print("Error: Token o usuarioId no válidos o ausentes");
        return;
      }
      final response = await inscripcionesApi.crearInscripcion(token, usuarioId, eventoId);

      if (response != null) {
        print("Inscripción exitosa para el evento: $eventoId");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Inscripción exitosa al evento")),
        );
        setState(() {
          userInscripcionesStatus[eventoId] = true;
        });
      } else {
        print("Error al inscribirse en el evento");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al inscribirse en el evento")),
        );
      }
    } catch (error) {
      print("Error al inscribirse en el evento: $error");
    }
  }

  void _openForm(BuildContext context, {EventoModelo? evento}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventoForm(
          evento: evento,
          onSave: evento == null ? _saveEvento : (updatedEvento) => _updateEvento(evento.id, updatedEvento),
        ),
      ),
    );
  }

  Future<void> _saveEvento(EventoModelo evento) async {
    try {
      await apiService.saveEvento(TokenUtil.TOKEN, evento);
      _loadData();
    } catch (error) {
      print("Error al guardar evento: $error");
    }
  }

  Future<void> _updateEvento(int eventId, EventoModelo evento) async {
    try {
      await apiService.updateEvento(TokenUtil.TOKEN, eventId, evento);
      _loadData();
    } catch (error) {
      print("Error al actualizar evento: $error");
    }
  }

  Future<void> _finalizarEvento(int eventId) async {
    try {
      final token = TokenUtil.TOKEN;

      if (token == null || token.isEmpty) {
        print("Error: Token no válido o ausente");
        return;
      }

      final response = await apiService.finalizarEvento(token, eventId);
      print("Respuesta de finalizar evento: $response");

      _loadData();
    } catch (error) {
      print("Error al finalizar evento: $error");
    }
  }

  void _confirmDelete(BuildContext context, int eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación de eliminación"),
          content: Text("¿Desea eliminar este evento?"),
          actions: [
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ACEPTAR'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await apiService.deleteEvento(TokenUtil.TOKEN, eventId);
                  _loadData();
                } catch (error) {
                  print("Error al eliminar evento: $error");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToFinalizedEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinalizedEventsScreen()),
    );
  }

  void _navigateToListaInscritos(int eventoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaInscritosScreen(eventoId: eventoId),
      ),
    );
  }

  void _toggleObservation(int eventoId) {
    setState(() {
      selectedEventoId = selectedEventoId == eventoId ? null : eventoId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Lista de Eventos')),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          //if (userRole == 'ROLE_ADMIN')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _openForm(context),
            ),
            IconButton(
              icon: Icon(Icons.event_available),
              onPressed: _navigateToFinalizedEvents,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: eventosList.length,
        itemBuilder: (context, index) {
          final evento = eventosList[index];
          final isUserRegistered = userInscripcionesStatus[evento.id] ?? false;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    evento.nombreDelEvento,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      selectedEventoId == evento.id ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.deepOrange,
                      size: 24.0,
                    ),
                    onPressed: () => _toggleObservation(evento.id),
                  ),
                  SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildInfoColumn(Icons.location_on, "Lugar", evento.direccionLugar),
                      _buildInfoColumn(Icons.map, "Referencia", evento.referencia),
                      _buildInfoColumn(Icons.calendar_today, "Fecha", evento.fecha),
                      _buildInfoColumn(Icons.access_time, "Hora", evento.hora),
                      _buildInfoColumn(Icons.timer, "Horas", evento.horasObtenidas),
                      _buildStatusIcon(evento.status),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [

                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _openForm(context, evento: evento),
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _confirmDelete(context, evento.id),
                        ),
                      IconButton(
                        icon: Icon(Icons.check_circle,
                            color: evento.status == "Activo" ? Colors.green : Colors.grey),
                        onPressed: evento.status == "Activo" ? () => _finalizarEvento(evento.id) : null,
                      ),
                        IconButton(
                          icon: Icon(Icons.list, color: Colors.blue),
                          onPressed: () => _navigateToListaInscritos(evento.id),
                        ),
                      ElevatedButton(
                        onPressed: isUserRegistered ? null : () => _inscribirseEnEvento(evento.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isUserRegistered ? Colors.grey : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isUserRegistered ? "Ya inscrito" : "Inscribirse"),
                      ),
                    ],
                  ),
                  if (selectedEventoId == evento.id)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Card(
                        color: Colors.orange[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            evento.observaciones ?? "No hay observaciones",
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: Colors.blueGrey),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusIcon(String status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle,
          color: status == "Activo" ? Colors.green : Colors.red,
          size: 20,
        ),
        SizedBox(height: 6),
        Text(
          "Estado",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: status == "Activo" ? Colors.green : Colors.red,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
