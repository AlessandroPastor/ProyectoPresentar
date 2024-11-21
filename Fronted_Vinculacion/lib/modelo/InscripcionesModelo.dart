import 'package:vinculacion/modelo/EventoModelo.dart';
import 'package:vinculacion/modelo/UsuarioModelo.dart';

class InscripcionModelo {
  final int id;
  final String fechaInscripcion;
  final String usuarioInscrito;
  final String estado;
  final int horasAsignadas;
  final UsuarioModelo usuario;
  final EventoModelo evento;

  InscripcionModelo({
    required this.id,
    required this.fechaInscripcion,
    required this.usuarioInscrito,
    required this.estado,
    required this.horasAsignadas,
    required this.usuario,
    required this.evento,
  });

  // Constructor para crear el modelo desde JSON
  factory InscripcionModelo.fromJson(Map<String, dynamic> json) {
    return InscripcionModelo(
      id: json['id'],
      fechaInscripcion: json['fechaInscripcion'],
      usuarioInscrito: json['usuario_inscrito'],
      estado: json['estado'],
      horasAsignadas: json['horasAsignadas'],
      usuario: UsuarioModelo.fromJson(json['usuario']),
      evento: EventoModelo.fromJson(json['evento']),
    );
  }

  get horasEditadas => null;


  // Método para convertir el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaInscripcion': fechaInscripcion,
      'usuario_inscrito': usuarioInscrito,
      'estado': estado,
      'horasAsignadas': horasAsignadas,
      'usuario': usuario.toJson(),
      'evento': evento.toJson(),
    };
  }
}
