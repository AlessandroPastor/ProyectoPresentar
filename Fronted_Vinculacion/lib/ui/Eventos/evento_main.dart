import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinculacion/apis/Evento/evento_api.dart';
import 'package:vinculacion/theme/AppTheme.dart';
import 'package:vinculacion/ui/Eventos/evento_ui.dart';

void main() {
  runApp(MainEvento());
}

class MainEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventoApi>(create: (_) => EventoApi.create()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: EventoUI(),
      ),
    );
  }
}
