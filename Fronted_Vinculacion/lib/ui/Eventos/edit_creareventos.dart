import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vinculacion/comp/CustomAppBarX.dart';
import 'package:vinculacion/modelo/EventoModelo.dart';

class EventoForm extends StatefulWidget {
  final EventoModelo? evento;
  final Function(EventoModelo) onSave;

  EventoForm({this.evento, required this.onSave});

  @override
  _EventoFormState createState() => _EventoFormState();
}

class _EventoFormState extends State<EventoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _direccionController;
  late TextEditingController _referenciaController;
  late TextEditingController _horasObtenidasController;
  late TextEditingController _observacionesController;

  DateTime? _selectedFecha;
  TimeOfDay? _selectedHora;
  late TextEditingController _fechaController;
  late TextEditingController _horaController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.evento?.nombreDelEvento ?? '');
    _direccionController = TextEditingController(text: widget.evento?.direccionLugar ?? '');
    _referenciaController = TextEditingController(text: widget.evento?.referencia ?? '');
    _horasObtenidasController = TextEditingController(text: widget.evento?.horasObtenidas ?? '0');
    _observacionesController = TextEditingController(text: widget.evento?.observaciones ?? '');

    _fechaController = TextEditingController();
    _horaController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Configuración de fecha y hora iniciales desde el evento, si existen
    if (widget.evento?.fecha != null) {
      try {
        _selectedFecha = DateFormat('dd-MM-yy').parse(widget.evento!.fecha!);
        _fechaController.text = DateFormat('yyyy-MM-dd').format(_selectedFecha!);
      } catch (e) {
        print("Error al parsear la fecha: $e");
      }
    }

    if (widget.evento?.hora != null) {
      try {
        final timeParts = widget.evento!.hora!.split(":");
        _selectedHora = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        _horaController.text = _selectedHora!.format(context);
      } catch (e) {
        print("Error al parsear la hora: $e");
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _referenciaController.dispose();
    _horasObtenidasController.dispose();
    _observacionesController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  Future<void> _pickFecha() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedFecha ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedFecha = pickedDate;
        _fechaController.text = DateFormat('yyyy-MM-dd').format(_selectedFecha!);
      });
    }
  }

  Future<void> _pickHora() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedHora ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedHora = pickedTime;
        _horaController.text = _selectedHora!.format(context);
      });
    }
  }

  DateTime _combineFechaHora(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.evento != null;
    String appBarTitle = isEditing ? 'Editar Evento' : 'Crear Evento';

    return Scaffold(
      appBar: CustomAppBarX(
        accionx: () {},
        showBackButton: false,
        title: appBarTitle,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nombreController,
                label: "Nombre del Evento",
                icon: Icons.event,
                validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              _buildTextField(
                controller: _direccionController,
                label: "Dirección del Lugar",
                icon: Icons.location_on,
                validator: (value) => value!.isEmpty ? "Ingrese una dirección" : null,
              ),
              _buildTextField(
                controller: _referenciaController,
                label: "Referencia",
                icon: Icons.map,
              ),
              _buildDatePickerField(),
              _buildTimePickerField(),
              _buildTextField(
                controller: _horasObtenidasController,
                label: "Horas Obtenidas",
                icon: Icons.timer,
              ),
              _buildTextField(
                controller: _observacionesController,
                label: "Observaciones",
                icon: Icons.note,
              ),
              SizedBox(height: 20),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text("Cancelar"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final DateTime fechaHoraCombinada = _combineFechaHora(
                          _selectedFecha ?? DateTime.now(),
                          _selectedHora ?? TimeOfDay.now(),
                        );

                        EventoModelo evento = EventoModelo(
                          id: widget.evento?.id ?? 0,
                          nombreDelEvento: _nombreController.text,
                          direccionLugar: _direccionController.text,
                          referencia: _referenciaController.text,
                          fecha: DateFormat('yyyy-MM-dd').format(fechaHoraCombinada),
                          hora: DateFormat('HH:mm').format(fechaHoraCombinada),
                          horasObtenidas: _horasObtenidasController.text,
                          observaciones: _observacionesController.text,
                          status: "Activo",
                        );
                        widget.onSave(evento);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(isEditing ? "Actualizar" : "Guardar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _fechaController,
        decoration: InputDecoration(
          labelText: "Fecha",
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        readOnly: true,
        onTap: _pickFecha,
      ),
    );
  }

  Widget _buildTimePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _horaController,
        decoration: InputDecoration(
          labelText: "Hora",
          prefixIcon: Icon(Icons.access_time, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        readOnly: true,
        onTap: _pickHora,
      ),
    );
  }
}
