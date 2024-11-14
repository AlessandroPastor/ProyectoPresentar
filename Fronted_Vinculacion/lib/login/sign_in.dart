import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

String? name;
String? email;
String imageUrl = "";
String error = "";

bool isGoogleSignIn = false; // Cambia a true cuando se inicia sesión con Google

Future<String> signInWithGoogle() async {
  try {
    await _googleSignIn.signIn();
  } catch (err) {
    print("Error al ingresar: ${err.toString()}");
    error = err.toString();
    Fluttertoast.showToast(
      msg: "Error al ingresar: $error",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return Future.error("Error al ingresar");
  }

  final GoogleSignInAccount? user = _googleSignIn.currentUser;

  if (user != null) {
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl ?? "";

    await saveUserInfo(); // Guarda los datos en SharedPreferences
    isGoogleSignIn = true; // Marca como inicio de sesión con Google
    return '$user';
  }
  return Future.error("No user found");
}


// Función para cerrar sesión y limpiar SharedPreferences
Future<void> signOutGoogle() async {
  await _googleSignIn.signOut();
  await clearUserInfo();
  print("User Signed Out");
}

// Guardar datos de usuario en SharedPreferences
Future<void> saveUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name ?? '');
  await prefs.setString('email', email ?? '');
  await prefs.setString('imageUrl', imageUrl);
}

// Cargar datos de usuario desde SharedPreferences
Future<void> loadUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  name = prefs.getString('name');
  email = prefs.getString('email');
  imageUrl = prefs.getString('imageUrl') ?? '';
}

// Limpiar datos de usuario de SharedPreferences
Future<void> clearUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('name');
  await prefs.remove('email');
  await prefs.remove('imageUrl');
}

// Ejemplo de uso en otro lugar para mostrar los datos
void showUserInfo() async {
  await loadUserInfo(); // Cargar los datos de SharedPreferences

  // Aquí puedes usar los datos de `name`, `email`, `imageUrl` como desees
  print("Nombre: $name");
  print("Correo electrónico: $email");
  print("URL de imagen: $imageUrl");
}
