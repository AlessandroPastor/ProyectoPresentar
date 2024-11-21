import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinculacion/drawer/profilescreen.dart';
import 'package:vinculacion/login/login_google.dart';
import 'package:vinculacion/login/sign_in.dart';
import 'package:vinculacion/theme/AppTheme.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {super.key,
        required this.screenIndex,
        required this.iconAnimationController,
        required this.callBackIndex});

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  String? carreraNombre;
  String? correo;
  String? nombres;


  @override
  void initState() {
    setDrawerListArray();
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombres = prefs.getString("userName") ?? "Anónimo";
      correo = prefs.getString("userEmail") ?? "anonimo@ejemplo.com";
      carreraNombre = prefs.getString("userCarrera") ?? "Carrera desconocida";
    });
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Principal',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Eventos,
        labelName: 'Eventos',
        icon: Icon(Icons.event),
      ),
      DrawerList(
        index: DrawerIndex.Horas,
        labelName: 'Cantidad de Horas',
        icon: Icon(Icons.access_time),
      ),
      DrawerList(
        index: DrawerIndex.Carrera,
        labelName: 'Carrera',
        icon: Icon(Icons.school),
      ),
      DrawerList(
        index: DrawerIndex.Calculadora,
        labelName: 'Calculadora',
        icon: Icon(Icons.calculate),
      ),
      DrawerList(
        index: DrawerIndex.Inscripciones,
        labelName: 'Mis Inscripciones',
        icon: Icon(Icons.assignment_turned_in),
      ),
      DrawerList(
        index: DrawerIndex.Juego,
        labelName: 'Juego',
        icon: Icon(Icons.videogame_asset),
      ),
      DrawerList(
        index: DrawerIndex.CrearUsuario,
        labelName: 'Crear Usuario',
        icon: Icon(Icons.person_add),
      ),
      DrawerList(
        index: DrawerIndex.Scaner,
        labelName: 'Scaner Objetos',
        icon: Icon(Icons.scanner),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                              begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(
                              parent: widget.iconAnimationController,
                              curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundImage: isGoogleSignIn
                                ? (imageUrl.isEmpty
                                ? AssetImage('assets/imagen/Logo_user.png')
                                : NetworkImage(imageUrl)) as ImageProvider
                                : AssetImage('assets/imagen/Logo_user.png'), // Imagen predeterminada para inicio de sesión tradicional
                            radius: 40,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Ver mi perfil",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          isGoogleSignIn ? name ?? "Anónimo" : nombres ?? "Anónimo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          isGoogleSignIn ? email ?? "anonimo@ejemplo.com" : correo ?? "anonimo@ejemplo.com",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          isGoogleSignIn ? "Sin carrera" : carreraNombre ?? "Carrera desconocida",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Salir',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }


  void onTapped() {
    signOutGoogle();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return LoginPage();
    }), ModalRoute.withName('/'));
    print('Doing Something...'); // Print to console.
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,

                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.themeData.primaryColor),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.themeData.primaryColor),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.themeData.primaryColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }


}

enum DrawerIndex {
  HOME,
  Eventos,
  Horas,
  Carrera,
  Calculadora,
  Inscripciones,
  Juego,
  CrearUsuario,
  Scaner,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    required this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
