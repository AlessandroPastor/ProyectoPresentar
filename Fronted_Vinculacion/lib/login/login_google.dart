import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinculacion/apis/Usuario/usuario_api.dart';
import 'package:vinculacion/drawer/navigation_home_screen.dart';
import 'package:vinculacion/login/sign_in.dart';
import 'package:vinculacion/modelo/UsuarioModelo.dart';
import 'package:vinculacion/modelo/rol.dart';
import 'package:vinculacion/theme/AppTheme.dart';
import 'package:vinculacion/util/TokenUtil.dart';

class MainLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<UsuarioApi>(
      create: (_) => UsuarioApi.create(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppTheme.lightColorSchemeBlue.primary,
          colorScheme: AppTheme.lightColorSchemeBlue,
          useMaterial3: AppTheme.useMaterial3,
        ),
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggedIn = false;
  bool modLocal = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();
  var tokenx;
  bool passwordVisible = false;
  String? nombres;
  String? apellidos;
  String? correo;
  String? carreraNombre;
  String? codigo;
  String? dni;
  String? cantidadDeHoras;
  String? userRole;


  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    cargarDatosUsuario();
  }

  // Método para cargar los datos del usuario desde SharedPreferences
  Future<void> cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombres = prefs.getString("userName") ?? "Anonimo";
      apellidos = prefs.getString("userApellidos") ?? "Apellido Animo";
      correo = prefs.getString("userEmail") ?? "anonimo@ejemplo.com";
      carreraNombre = prefs.getString("userCarrera") ?? "Carrera no especificada";
      codigo = prefs.getString("userCodigo") ?? "Codigo no encontrado";
      dni = prefs.getString("userDni") ?? "Dni no encontrado";
      cantidadDeHoras = prefs.getString("userHoras") ?? 'Cantidad Horas Erronea';
      userRole = prefs.getString("userRol") ?? "Usuario sin Rol";
      print("Rol del usuario cargado: $userRole");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/imagen/logo_upeu.png"),
                  height: 180.0,
                ),
                SizedBox(height: 20),
                _buildForm(),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: AppTheme.lightColorSchemeBlue.onSurfaceVariant,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "O",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.lightColorSchemeBlue.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: AppTheme.lightColorSchemeBlue.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _signInButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: "Usuario",
                labelText: "Usuario",
                helperText: "Coloque un correo",
                helperStyle: TextStyle(
                  color: AppTheme.lightColorSchemeBlue.secondary,
                ),
                filled: true,
              ),
              controller: _controllerUser,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su correo';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              obscureText: passwordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: "Password",
                labelText: "Password",
                helperText: "La contraseña debe contener un carácter especial",
                helperStyle: TextStyle(
                  color: AppTheme.lightColorSchemeGreen.secondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.lightColorSchemeBlue.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                filled: true,
              ),
              controller: _controllerPass,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightColorSchemeBlue.primary,
                foregroundColor: AppTheme.lightColorSchemeBlue.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Ingresar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final prefs = await SharedPreferences.getInstance();
                  final api = Provider.of<UsuarioApi>(context, listen: false);
                  final user = UsuarioModelo.login(
                    _controllerUser.text,
                    _controllerPass.text,
                  );

                  try {
                    final value = await api.login(user);

                    final tokenx = "Bearer " + value.token;
                    await prefs.setString("token", tokenx);
                    TokenUtil.TOKEN = tokenx;

                    await prefs.setString("userName", value.nombres ?? "Anónimo");
                    await prefs.setString("userApellidos", value.apellidos ?? "Anónimo");
                    await prefs.setString("userEmail", value.correo ?? "anonimo@ejemplo.com");
                    await prefs.setString("userCarrera", value.carreraNombre ?? "Carrera no especificada");
                    await prefs.setString("userCodio", value.codigo ?? "Codigo no encontrado");
                    await prefs.setString("userDni", value.dni ?? "Dni no encontrado");
                    await prefs.setInt("usuarioId", value.id); // Guardar usuarioId
                    await prefs.setString("userHoras", value.cantidadDeHoras ?? '0');
                    if (value.roles.isNotEmpty) {
                      await prefs.setString("userRol", value.roles[0].rolNombre.toString());
                    } else {
                      await prefs.setString("userRol", "Usuario sin Rol");
                    }



                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NavigationHomeScreen();
                        },
                      ),
                    );
                  } catch (error) {
                    print(error.toString());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlinedButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        signInWithGoogle().then((result) async {
          if (result != null) {
            final api = Provider.of<UsuarioApi>(context, listen: false);
            final user = UsuarioModelo.login("cabana@gmail.com", "Cris12345@");
            try {
              final value = await api.login(user);

              tokenx = "Bearer " + value.token;
              await prefs.setString("token", tokenx);
              TokenUtil.TOKEN = tokenx;

              await prefs.setString("userName", value.nombres ?? "Anónimo");
              await prefs.setString("userApellido", value.apellidos ?? "anonimo@ejemplo.com");
              await prefs.setString("userEmail", value.correo ?? "anonimo@ejemplo.com");
              await prefs.setString("userCarrera", value.carreraNombre ?? "Carrera no especificada");
              await prefs.setString("userCodigo", value.codigo ?? "Codigo no encontrado");
              await prefs.setString("userDni", value.dni ?? "Dni no encontrado");
              await prefs.setString("userHoras", value.cantidadDeHoras ?? "Dni no encontrado");
              // Guardar el rol principal del usuario
              if (value.roles.isNotEmpty) {
                // Acceder al primer rol en la lista de roles
                await prefs.setString("userRol", value.roles[0].rolNombre as String);
              } else {
                await prefs.setString("userRol", "Usuario sin Rol");
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return NavigationHomeScreen();
                  },
                ),
              );
            } catch (error) {
              print(error.toString());
            }
          } else {
            print("Error!");
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/imagen/GoogleIngreso.jpeg"),
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Ingresar Google',
                style: TextStyle(
                  fontSize: 20,
                  color: AppTheme.lightColorSchemeBlue.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
