import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vinculacion/comp/CustomAppBarX.dart';
import 'package:vinculacion/theme/AppTheme.dart';
import 'package:vinculacion/ui/Eventos_ScreenHelp/actualizaciones.dart';
import 'package:vinculacion/ui/Eventos_ScreenHelp/configuracion.dart';
import 'package:vinculacion/ui/Eventos_ScreenHelp/seguridad.dart';
import 'package:vinculacion/ui/Eventos_ScreenHelp/soporte.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  void accion() {
    setState(() {});
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'pinguinosdelinux@gmail.com',
      query: 'subject=Consulta sobre la aplicación de Vinculación',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo abrir el cliente de correo")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: AppTheme.themeDataLight,
      darkTheme: AppTheme.themeDataDark,
      home: SafeArea(
        top: false,
        child: Scaffold(
          appBar: CustomAppBarX(
            accionx: accion as Function,
            title: 'Vinculación',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top + 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, color: Colors.blue, size: 40),
                    SizedBox(width: 10),
                    Text(
                      "Centro de Vinculación",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.green, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Encuentra apoyo e información sobre el uso de la aplicación",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(8),
                    children: [
                      _buildHelpCard(
                        icon: Icons.settings,
                        color: Colors.purple,
                        title: "Configuración",
                        description: "Ajusta la configuración de la aplicación.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfiguracionScreen(),
                            ),
                          );
                        },
                      ),
                      _buildHelpCard(
                        icon: Icons.security,
                        color: Colors.red,
                        title: "Seguridad",
                        description: "Aprende cómo proteger tu cuenta.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeguridadScreen(),
                            ),
                          );
                        },
                      ),
                      _buildHelpCard(
                        icon: Icons.contact_support,
                        color: Colors.blue,
                        title: "Soporte",
                        description: "Contacta con nuestro equipo de soporte.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SoporteScreen(),
                            ),
                          );
                        },
                      ),
                      _buildHelpCard(
                        icon: Icons.update,
                        color: Colors.orange,
                        title: "Actualizaciones",
                        description: "Conoce las últimas novedades de la aplicación.",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActualizacionesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _launchEmail, // Llama a la función para abrir el correo
                  icon: Icon(Icons.email, color: Colors.white),
                  label: Text("pinguinosdelinux@gmail.com"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}
