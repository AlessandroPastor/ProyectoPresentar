import 'package:json_annotation/json_annotation.dart';
import 'package:vinculacion/modelo/rol.dart';

@JsonSerializable()
class UsuarioModelo {
  UsuarioModelo({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.password,
    required this.token,
    required this.dni,
    required this.codigo,
    required this.estado,
    required this.cantidadDeHoras,
    required this.carreraId,
    required this.carreraNombre,

  });

  // Constructor simplificado para login
  UsuarioModelo.login(this.correo, this.password)
      : nombres = "",
        apellidos = "",
        token = "",
        dni = "",
        codigo = "",
        estado = "",
        cantidadDeHoras = "0",
        carreraId = null,
        carreraNombre = null;

  final String nombres;
  final String apellidos;
  final String correo;
  final String password;
  final String token;
  final String dni;
  final String codigo;
  final String estado;
  final String cantidadDeHoras;
  final int? carreraId;
  final String? carreraNombre;

  // Método de fábrica para crear una instancia desde JSON con manejo de valores nulos
  factory UsuarioModelo.fromJson(Map<String, dynamic> json) {
    return UsuarioModelo(
      nombres: json['nombres'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      password: json['password'] as String? ?? '',
      token: json['token'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      cantidadDeHoras: json['cantidad_de_horas'] as String? ?? '0',
      carreraId: json['carreraId'] as int?,
      carreraNombre: json['carreraNombre'] as String?,
    );
  }

  // Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'password': password,
      'token': token,
      'dni': dni,
      'codigo': codigo,
      'estado': estado,
      'cantidad_de_horas': cantidadDeHoras,
      'carreraId': carreraId,
      'carreraNombre': carreraNombre,
    };
  }
}

class RespUsuarioModelo {
  RespUsuarioModelo({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.token,
    required this.dni,
    required this.codigo,
    required this.estado,
    required this.cantidadDeHoras,
    required this.carreraId,
    required this.carreraNombre,
    required this.roles,
  });

  final int id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String token;
  final String dni;
  final String codigo;
  final String estado;
  final String cantidadDeHoras;
  final int? carreraId;
  final String carreraNombre;
  final List<Rol> roles; // Lista de roles

  // Método de fábrica para crear una instancia desde JSON con manejo de valores nulos
  factory RespUsuarioModelo.fromJson(Map<String, dynamic> json) {
    return RespUsuarioModelo(
      id: json['id'] as int? ?? 0,
      nombres: json['nombres'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      token: json['token'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      cantidadDeHoras: json['cantidad_de_horas'] as String? ?? '0',
      carreraId: json['carreraId'] as int?,
      carreraNombre: json['carreraNombre'] as String,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Rol.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // Método para convertir la instancia en un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'token': token,
      'dni': dni,
      'codigo': codigo,
      'estado': estado,
      'cantidad_de_horas': cantidadDeHoras,
      'carreraId': carreraId,
      'carreraNombre': carreraNombre,
      'roles': roles.map((rol) => rol.toJson()).toList(),
    };
  }
}
@JsonSerializable()
class UsuarioCrearDto {
  final String nombres;
  final String apellidos;
  final String correo;
  final String password;
  final String token;
  final String dni;
  final String codigo;
  final String estado;
  final int cantidad_de_horas;
  final String rolx;
  final int carreraId;
  final List<Rol> roles;

  UsuarioCrearDto({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.password,
    required this.token,
    required this.dni,
    required this.codigo,
    required this.estado,
    required this.cantidad_de_horas,
    required this.rolx,
    required this.carreraId,
    required this.roles,
  });

  // Método para convertir la instancia a JSON para la API
  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'password': password,
      'token': token,
      'dni': dni,
      'codigo': codigo,
      'estado': estado,
      'cantidad_de_horas': cantidad_de_horas.toString(),
      'rolx': rolx,
      'carreraId': carreraId,
      'roles': roles.map((rol) => rol.toJson()).toList(),
    };
  }
}


