import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinculacion/apis/Evento/evento_api.dart';
import 'package:vinculacion/comp/CustomAppBarX.dart';
import 'package:vinculacion/modelo/EventoModelo.dart';
import 'package:vinculacion/ui/Eventos/inscritosscreen.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class FinalizedEventsScreen extends StatefulWidget {
  @override
  _FinalizedEventsScreenState createState() => _FinalizedEventsScreenState();
}

class _FinalizedEventsScreenState extends State<FinalizedEventsScreen> {
  late EventoApi apiService;
  late List<EventoModelo> finalizedEvents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    apiService = EventoApi.create();
    _loadData();
  }

  _loadData() async {
    setState(() => _isLoading = true);
    try {
      var data = await Provider.of<EventoApi>(context, listen: false).list(TokenUtil.TOKEN);
      setState(() {
        finalizedEvents = data.where((evento) => evento.status == "Finalizado").toList();
      });
    } catch (error) {
      print("Error al cargar eventos finalizados: $error");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void accion() {
    setState(() {});
  }

  void _navigateToListaInscritos(int eventoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaInscritosScreen(eventoId: eventoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarX(
        accionx: accion,
        showBackButton: false,
        title: 'Eventos Finalizados',
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: finalizedEvents.length,
              itemBuilder: (context, index) {
                final evento = finalizedEvents[index];
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.group),
                              label: Text("Ver Inscritos"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _navigateToListaInscritos(evento.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Regresar a Eventos Activos",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
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
          color: status == "Finalizado" ? Colors.red : Colors.green,
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
            color: status == "Finalizado" ? Colors.red : Colors.green,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
