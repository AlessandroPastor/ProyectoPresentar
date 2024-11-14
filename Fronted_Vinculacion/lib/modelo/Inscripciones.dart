import 'package:json_annotation/json_annotation.dart';

// EventoDto.dart
@JsonSerializable()
class EventoDto {
  final int id;
  final String nombreDelEvento;
  final String direccionLugar;
  final String referencia;
  final int fecha;
  final String hora;
  final String horasObtenidas;
  final String observaciones;
  final String status;
  final List<InscripcionDto> inscripciones;

  EventoDto({
    required this.id,
    required this.nombreDelEvento,
    required this.direccionLugar,
    required this.referencia,
    required this.fecha,
    required this.hora,
    required this.horasObtenidas,
    required this.observaciones,
    required this.status,
    required this.inscripciones,
  });

  // Método para convertir JSON en una instancia de EventoDto
  factory EventoDto.fromJson(Map<String, dynamic> json) {
    return EventoDto(
      id: json['id'],
      nombreDelEvento: json['nombreDelEvento'],
      direccionLugar: json['direccionLugar'],
      referencia: json['referencia'],
      fecha: json['fecha'],
      hora: json['hora'],
      horasObtenidas: json['horasObtenidas'],
      observaciones: json['observaciones'],
      status: json['status'],
      inscripciones: (json['inscripciones'] as List)
          .map((item) => InscripcionDto.fromJson(item))
          .toList(),
    );
  }

  // Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreDelEvento': nombreDelEvento,
      'direccionLugar': direccionLugar,
      'referencia': referencia,
      'fecha': fecha,
      'hora': hora,
      'horasObtenidas': horasObtenidas,
      'observaciones': observaciones,
      'status': status,
      'inscripciones': inscripciones.map((item) => item.toJson()).toList(),
    };
  }
}




// InscripcionDto.dart
@JsonSerializable()
class InscripcionDto {
  final int id;
  final int usuarioId;
  final String nombreUsuario;
  final String estado;
  late final int? horasEditadas;
  final List<dynamic> fechaInscripcion;
  final List<UsuarioInfo> usuarioinfo;

  InscripcionDto({
    required this.id,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.estado,
    required this.horasEditadas,
    required this.fechaInscripcion,
    required this.usuarioinfo,
  });

  // Método para convertir JSON en una instancia de InscripcionDto
  factory InscripcionDto.fromJson(Map<String, dynamic> json) {
    return InscripcionDto(
      id: json['id'],
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      estado: json['estado'],
      horasEditadas: json['horasEditadas'],
      fechaInscripcion: json['fechaInscripcion'],
      usuarioinfo: (json['usuarioinfo'] as List)
          .map((item) => UsuarioInfo.fromJson(item))
          .toList(),
    );
  }

  // Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'nombreUsuario': nombreUsuario,
      'estado': estado,
      'horasEditas': horasEditadas,
      'fechaInscripcion': fechaInscripcion,
      'usuarioinfo': usuarioinfo.map((item) => item.toJson()).toList(),
    };
  }

  // Formatear `fechaInscripcion` para ser legible
  String get formattedFechaInscripcion {
    if (fechaInscripcion.length == 3) {
      return "${fechaInscripcion[2].toString().padLeft(2, '0')}/${fechaInscripcion[1].toString().padLeft(2, '0')}/${fechaInscripcion[0]}";
    }
    return "Fecha no disponible";
  }
}

// UsuarioInfo.dart
@JsonSerializable()
class UsuarioInfo {
  final String nombres;
  final String apellidos;
  final String codigo;

  UsuarioInfo({
    required this.nombres,
    required this.apellidos,
    required this.codigo,
  });

  // Método para convertir JSON en una instancia de UsuarioInfo
  factory UsuarioInfo.fromJson(Map<String, dynamic> json) {
    return UsuarioInfo(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      codigo: json['codigo'],
    );
  }

  // Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'codigo': codigo,
    };
  }
}
