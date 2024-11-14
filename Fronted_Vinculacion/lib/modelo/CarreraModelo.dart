import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class CarreraDto {
  int? id;
  String? nombreFacultad;
  List<UsuarioDto>? usuarios;

  CarreraDto({
    this.id,
    this.nombreFacultad,
    this.usuarios,
  });

  // Convert JSON to CarreraDto object
  factory CarreraDto.fromJson(Map<String, dynamic> json) {
    return CarreraDto(
      id: json['id'] as int?,
      nombreFacultad: json['nombre_facultad'] as String?, // Mapeo manual del campo JSON
      usuarios: json['usuarios'] != null
          ? (json['usuarios'] as List)
          .map((usuarioJson) => UsuarioDto.fromJson(usuarioJson))
          .toList()
          : [],
    );
  }

  // Convert CarreraDto object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_facultad': nombreFacultad, // Mapeo manual del campo JSON
      'usuarios': usuarios?.map((usuario) => usuario.toJson()).toList(),
    };
  }
}
@JsonSerializable()
class UsuarioDto {
  int? id;
  String? nombres;
  String? apellidos;
  String? codigo;

  UsuarioDto({
    this.id,
    this.nombres,
    this.apellidos,
    this.codigo,
  });

  // Convert JSON to UsuarioDto object
  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      id: json['id'] as int?,
      nombres: json['nombres'] as String?,
      apellidos: json['apellidos'] as String?,
      codigo: json['codigo'] as String?,
    );
  }

  // Convert UsuarioDto object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'codigo': codigo,
    };
  }
}
