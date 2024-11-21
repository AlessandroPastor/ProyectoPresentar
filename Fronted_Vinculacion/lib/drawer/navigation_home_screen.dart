//import 'package:asistencia_upeu/ui/Eventos/MainEvento.dart';
import 'package:flutter/material.dart';
import 'package:vinculacion/drawer/crear_usuario.dart';
import 'package:vinculacion/drawer/drawer_user_controller.dart';
import 'package:vinculacion/drawer/home_drawer.dart';
import 'package:vinculacion/main.dart';
import 'package:vinculacion/theme/AppTheme.dart';
import 'package:vinculacion/ui/Calculadora/Calculadora.dart';
import 'package:vinculacion/ui/CantidadHoras/Horas.dart';
import 'package:vinculacion/ui/Carrera/carrera_main.dart';
import 'package:vinculacion/ui/EscanerObjetos/ScaneerMain.dart';
import 'package:vinculacion/ui/Eventos/evento_main.dart';
import 'package:vinculacion/ui/Inscripciones/Inscrpciones.dart';
import 'package:vinculacion/ui/Juego/Tictatoe.dart';
import 'package:vinculacion/ui/help_screen.dart';


class NavigationHomeScreen extends StatefulWidget {

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  get token => null;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HelpScreen();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppTheme.themeData.primaryColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.themeData.primaryColor,
          //appBar: CustomAppBar(accionx: accion as Function),
          body: DrawerUserController(
            screenIndex: drawerIndex!!,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView!!,
            drawerIsOpen: (bool ) {  },
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HelpScreen(); // Primera Página
        });
      } else if (drawerIndex == DrawerIndex.Calculadora) {
        setState(() {
          screenView = CalcApp();
        });
      }else if (drawerIndex == DrawerIndex.Eventos) {
        setState(() {
          screenView = MainEvento();
        });
      }
      else if (drawerIndex == DrawerIndex.Horas) {
        setState(() {
          screenView = UsuarioDetalleAdminUI();
        });
      }
      else if (drawerIndex == DrawerIndex.Carrera) {
        setState(() {
          screenView = CarreraListScreen();
        });
      }
      else if (drawerIndex == DrawerIndex.Scaner) {
        setState(() {
          screenView =  SimpleImageCaptureScreen();
        });
      }
      else if (drawerIndex == DrawerIndex.CrearUsuario) {
        setState(() {
          screenView = CrearUsuarioScreen();

        });
      }
      else if (drawerIndex == DrawerIndex.Juego) {
        setState(() {
          screenView = TicTacToeApp();

        });
      }
      else if (drawerIndex == DrawerIndex.Inscripciones) {
        setState(() {
          screenView = InscripcionesScreen();
        });
      }
      else {
        // Aquí puedes agregar una pantalla por defecto o manejar otros casos
      }
    }
  }

}
