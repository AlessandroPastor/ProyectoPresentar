import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EventoModelo {
  EventoModelo({
    required this.id,
    required this.nombreDelEvento,
    required this.direccionLugar,
    required this.referencia,
    required this.fecha,
    required this.hora,
    required this.horasObtenidas,
    required this.observaciones,
    required this.status,
  });

  final int id;
  final String nombreDelEvento;
  final String direccionLugar;
  final String referencia;
  final String fecha; // Ahora como String
  final String hora;
  final String horasObtenidas;
  final String observaciones;
  final String status;

  // Método de fábrica para crear una instancia desde JSON con manejo de nombres en snake_case
  factory EventoModelo.fromJson(Map<String, dynamic> json) {
    return EventoModelo(
      id: json['id'] as int? ?? 0,
      nombreDelEvento: json['nombre_del_evento'] as String? ?? '',
      direccionLugar: json['direccion_lugar'] as String? ?? '',
      referencia: json['referencia'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '', // Fecha predeterminada en caso de que falte
      hora: json['hora'] as String? ?? '',
      horasObtenidas: json['horas_obtenidas'] as String? ?? '0',
      observaciones: json['observaciones'] as String? ?? '',
      status: json['status'] as String? ?? 'inactivo',
    );
  }

  // Método para convertir la instancia en un mapa JSON con nombres en snake_case
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_del_evento': nombreDelEvento,
      'direccion_lugar': direccionLugar,
      'referencia': referencia,
      'fecha': fecha,
      'hora': hora,
      'horas_obtenidas': horasObtenidas,
      'observaciones': observaciones,
      'status': status,
    };
  }
}
