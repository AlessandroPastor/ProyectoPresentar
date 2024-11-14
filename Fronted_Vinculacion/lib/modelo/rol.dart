import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Rol {
  final int id;
  final RolNombre rolNombre;

  Rol({
    required this.id,
    required this.rolNombre,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'] as int,
      rolNombre: rolNombreFromString(json['rolNombre'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rolNombre': rolNombreToString(rolNombre),
    };
  }


  static String rolNombreToString(RolNombre rolNombre) {
    switch (rolNombre) {
      case RolNombre.ROLE_ADMIN:
        return 'ROLE_ADMIN';
      case RolNombre.ROLE_USER:
        return 'ROLE_USER';
    }
  }

  static RolNombre rolNombreFromString(String rol) {
    switch (rol) {
      case 'ROLE_ADMIN':
        return RolNombre.ROLE_ADMIN;
      case 'ROLE_USER':
        return RolNombre.ROLE_USER;
      default:
        throw Exception("RolNombre no válido: $rol");
    }
  }
}

enum RolNombre {
  ROLE_ADMIN,
  ROLE_USER,
}
