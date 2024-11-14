import 'package:flutter/material.dart';
import 'package:vinculacion/apis/Carrera/carrera_api.dart';
import 'package:vinculacion/modelo/CarreraModelo.dart';
import 'package:vinculacion/ui/Carrera/carrera_form.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class CarreraListScreen extends StatefulWidget {
  @override
  _CarreraListScreenState createState() => _CarreraListScreenState();
}

class _CarreraListScreenState extends State<CarreraListScreen> {
  List<CarreraDto> carreras = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarreras();
  }

  void _fetchCarreras() async {
    setState(() => isLoading = true);
    final api = CarreraApi.create();
    try {
      final token = TokenUtil.TOKEN;
      if (token != null && token.isNotEmpty) {
        List<CarreraDto> fetchedCarreras = await api.listCarreras(token);
        print("Datos recibidos: ${fetchedCarreras.map((c) => c.nombreFacultad).toList()}");
        setState(() {
          carreras = fetchedCarreras;
          isLoading = false;
        });
      } else {
        print("Token is missing. Unable to fetch carreras.");
      }
    } catch (e) {
      print("Error fetching carreras: $e");
      setState(() => isLoading = false);
    }
  }

  void _navigateToForm([CarreraDto? carrera]) async {
    bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarreraFormScreen(carrera: carrera),
      ),
    );
    if (isUpdated == true) {
      _fetchCarreras();
    }
  }

  Future<void> _deleteCarrera(int id) async {
    try {
      final api = CarreraApi.create();
      final token = TokenUtil.TOKEN;
      if (token != null && token.isNotEmpty) {
        await api.deleteCarrera(token, id);
        _fetchCarreras();
      } else {
        print("Token is missing. Unable to delete carrera.");
      }
    } catch (error) {
      print("Error deleting carrera: $error");
    }
  }

  void _showUsuarios(int carreraId) async {
    final api = CarreraApi.create();
    final token = TokenUtil.TOKEN;
    try {
      if (token != null && token.isNotEmpty) {
        CarreraDto carrera = await api.getCarreraById(token, carreraId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsuarioListScreen(usuarios: carrera.usuarios ?? []),
          ),
        );
      } else {
        print("Token is missing. Unable to fetch users.");
      }
    } catch (e) {
      print("Error fetching users for carrera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Lista de Carreras'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToForm(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: carreras.length,
        itemBuilder: (context, index) {
          final carrera = carreras[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                carrera.nombreFacultad ?? 'Sin nombre',
                style: TextStyle(color: carrera.nombreFacultad != null ? Colors.black : Colors.red),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.group),
                    onPressed: () => _showUsuarios(carrera.id!),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToForm(carrera),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(carrera.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(int carreraId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Está seguro de que desea eliminar esta carrera?"),
          actions: [
            TextButton(
              child: Text("CANCELAR"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("ELIMINAR"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCarrera(carreraId);
              },
            ),
          ],
        );
      },
    );
  }
}

class UsuarioListScreen extends StatelessWidget {
  final List<UsuarioDto> usuarios;

  UsuarioListScreen({required this.usuarios});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuarios de la Carrera"),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario.nombres ?? 'Sin nombre'),
            subtitle: Text(usuario.codigo ?? 'Sin código'),
          );
        },
      ),
    );
  }
}
