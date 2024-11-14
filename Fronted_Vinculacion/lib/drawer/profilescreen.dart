import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nombres;
  String? apellidos;
  String? correo;
  String? carreraNombre;
  String? codigo;
  String? dni;
  String? cantidadDeHoras;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombres = prefs.getString("userName") ?? "Anónimo";
      apellidos = prefs.getString("userApellidos") ?? "Sin apellido";
      correo = prefs.getString("userEmail") ?? "anonimo@ejemplo.com";
      carreraNombre = prefs.getString("userCarrera") ?? "Carrera desconocida";
      codigo = prefs.getString("userCodigo") ?? "Código no disponible";
      dni = prefs.getString("userDni") ?? "DNI no disponible";
      cantidadDeHoras = prefs.getString("userHoras") ?? "0";
    });
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/imagen/Logo_user.png'),
              radius: 60,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Text(
              "$nombres $apellidos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildInfoCard(Icons.email, "Correo", correo ?? "anonimo@ejemplo.com", Colors.blue),
            _buildInfoCard(Icons.school, "Carrera", carreraNombre ?? "Carrera desconocida", Colors.green),
            _buildInfoCard(Icons.badge, "Código", codigo ?? "Código no disponible", Colors.deepPurple),
            _buildInfoCard(Icons.credit_card, "DNI", dni ?? "DNI no disponible", Colors.orange),
            _buildInfoCard(Icons.access_time, "Horas Acumuladas", cantidadDeHoras ?? "0", Colors.redAccent),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Regresar"),
            ),
          ],
        ),
      ),
    );
  }
}
