import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Usuario/usuario_api.dart';
import 'package:vinculacion/comp/CustomAppBarX.dart';
import 'package:vinculacion/modelo/UsuarioModelo.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class UsuarioDetalleAdminUI extends StatefulWidget {
  @override
  _UsuarioDetalleAdminUIState createState() => _UsuarioDetalleAdminUIState();
}

class _UsuarioDetalleAdminUIState extends State<UsuarioDetalleAdminUI> {
  late UsuarioApi apiService;
  UsuarioModelo? usuario;
  bool _isLoading = false;
  TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = UsuarioApi.create();
  }

  _buscarUsuario() async {
    setState(() {
      _isLoading = true;
      usuario = null;
    });

    try {
      final token = TokenUtil.TOKEN;
      if (token != null && token.isNotEmpty) {
        String criterioBusqueda = _busquedaController.text.trim();
        UsuarioModelo? fetchedUsuario;
        try {
          fetchedUsuario = await apiService.buscarPorDni(token, criterioBusqueda);
        } catch (error) {
          print("Usuario no encontrado por DNI, buscando por código.");
        }

        if (fetchedUsuario == null) {
          try {
            fetchedUsuario = await apiService.buscarPorCodigo(token, criterioBusqueda);
          } catch (error) {
            print("Usuario no encontrado por código.");
          }
        }

        setState(() {
          usuario = fetchedUsuario;
        });
      } else {
        print("Token no válido o ausente en TokenUtil.");
      }
    } catch (error) {
      print("Error al buscar usuario: $error");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarX(
        accionx: _buscarUsuario,
        title: 'Buscar Usuario',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                labelText: "Ingrese DNI o Código del estudiante",
                labelStyle: TextStyle(color: Colors.grey[800]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[800], size: 24),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[800], size: 24),
                  onPressed: () {
                    _busquedaController.clear();
                  },
                ),
              ),
              onSubmitted: (value) {
                if (_busquedaController.text.trim().isNotEmpty) {
                  _buscarUsuario();
                } else {
                  print("Por favor, ingrese un DNI o Código válido.");
                }
              },
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.grey[700]))
                : usuario == null
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "No se encontró el usuario.",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            )
                : _buildUsuarioInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsuarioInfo() {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Colors.grey[500],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${usuario!.nombres} ${usuario!.apellidos}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey[300]),
              _buildInfoItem(icon: Icons.email, title: "Correo", value: usuario!.correo),
              _buildInfoItem(icon: Icons.credit_card, title: "DNI", value: usuario!.dni),
              _buildInfoItem(icon: Icons.badge, title: "Código", value: usuario!.codigo),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.grey[100]!,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      "Cantidad de Horas",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${usuario!.cantidadDeHoras}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Estado: ${usuario!.estado}",
                style: TextStyle(
                  fontSize: 16,
                  color: usuario!.estado == "Activo" ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String title, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[800], size: 28),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[800]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
