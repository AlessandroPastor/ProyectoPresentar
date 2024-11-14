import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Carrera/carrera_api.dart';
import 'package:vinculacion/apis/Usuario/usuario_api.dart';
import 'package:vinculacion/modelo/UsuarioModelo.dart';
import 'package:vinculacion/modelo/rol.dart';
import 'package:vinculacion/modelo/CarreraModelo.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class CrearUsuarioScreen extends StatefulWidget {
  @override
  _CrearUsuarioScreenState createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dniController = TextEditingController();
  final _codigoController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cantidadDeHorasController = TextEditingController();

  String? _selectedRolx;
  RolNombre? _selectedRol;
  CarreraDto? _selectedCarrera;

  late UsuarioApi authApi;
  late CarreraApi carreraApi;
  List<CarreraDto> _carreras = [];

  @override
  void initState() {
    super.initState();
    authApi = UsuarioApi.create();
    carreraApi = CarreraApi.create();
    _fetchCarreras();
  }

  Future<void> _fetchCarreras() async {
    try {
      final token = TokenUtil.TOKEN;
      if (token != null && token.isNotEmpty) {
        final carreras = await carreraApi.listCarreras(token);
        setState(() {
          _carreras = carreras;
        });
      } else {
        print("Error: El token no está disponible.");
      }
    } catch (error) {
      print("Error al cargar carreras: $error");
    }
  }

  Future<void> _crearUsuario() async {
    if (_formKey.currentState!.validate()) {
      final newUser = UsuarioCrearDto(
        nombres: _nombresController.text,
        apellidos: _apellidosController.text,
        correo: _correoController.text,
        password: _passwordController.text,
        token: TokenUtil.TOKEN,
        dni: _dniController.text,
        codigo: _codigoController.text,
        estado: _estadoController.text,
        cantidad_de_horas: int.tryParse(_cantidadDeHorasController.text) ?? 0,
        rolx: _selectedRolx ?? "ALUMNO",
        carreraId: _selectedCarrera?.id ?? 1,
        roles: [
          _selectedRol == RolNombre.ROLE_ADMIN
              ? Rol(id: 1, rolNombre: RolNombre.ROLE_ADMIN)
              : Rol(id: 2, rolNombre: RolNombre.ROLE_USER),
        ],
      );

      try {
        await authApi.register(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario creado con éxito")),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear usuario: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Crear Usuario"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Formulario de Creación de Usuario",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField("Nombres", _nombresController),
              _buildTextField("Apellidos", _apellidosController),
              _buildTextField("Correo", _correoController),
              _buildTextField("Contraseña", _passwordController, obscureText: true),
              _buildTextField("DNI", _dniController),
              _buildTextField("Código", _codigoController),
              _buildTextField("Estado", _estadoController),
              _buildTextField("Cantidad de Horas", _cantidadDeHorasController, keyboardType: TextInputType.number),

              DropdownButtonFormField<String>(
                value: _selectedRolx,
                decoration: InputDecoration(
                  labelText: "Rolx",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: ["ALUMNO", "EGRESADO"].map((rol) => DropdownMenuItem(
                  value: rol,
                  child: Text(rol),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRolx = value;
                  });
                },
                validator: (value) => value == null ? "Selecciona un rol" : null,
              ),

              DropdownButtonFormField<RolNombre>(
                value: _selectedRol,
                decoration: InputDecoration(
                  labelText: "Rol",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: RolNombre.values
                    .map((rol) => DropdownMenuItem(
                  value: rol,
                  child: Text(rol == RolNombre.ROLE_ADMIN ? "ROLE_ADMIN" : "ROLE_USER"),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRol = value;
                  });
                },
                validator: (value) => value == null ? "Selecciona un rol" : null,
              ),

              DropdownButtonFormField<CarreraDto>(
                value: _selectedCarrera,
                decoration: InputDecoration(
                  labelText: "Carrera",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: _carreras.map((carrera) => DropdownMenuItem(
                  value: carrera,
                  child: Text(carrera.nombreFacultad ?? "Sin nombre"),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCarrera = value;
                  });
                },
                validator: (value) => value == null ? "Selecciona una carrera" : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearUsuario,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text("Crear Usuario", style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
      ),
    );
  }
}
