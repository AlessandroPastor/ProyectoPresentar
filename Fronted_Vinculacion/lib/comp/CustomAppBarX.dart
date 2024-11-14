import 'package:flutter/material.dart';
import 'package:vinculacion/theme/AppTheme.dart';

class CustomAppBarX extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBarX({
    Key? key,
    required this.accionx,
    this.showBackButton = false,
    required this.title,
  }) : preferredSize = const Size.fromHeight(60.0), super(key: key);

  final Function accionx;
  final bool showBackButton;
  final String title;

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarX> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: AppTheme.colorOptions[AppTheme.colorSelected],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(5),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.colorOptionsShemeL[AppTheme.colorSelected].onPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          Spacer(),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorOptionsShemeL[AppTheme.colorSelected].onPrimary,
            ),
          ),
          Spacer(),
        ],
      ),
      actions: [
        _buildThemeToggleIcon(),
        _buildMaterialVersionToggleIcon(),
        _buildColorSelectionMenu(),
      ],
    );
  }

  Widget _buildThemeToggleIcon() {
    return IconButton(
      icon: Icon(
        AppTheme.useLightMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        color: AppTheme.colorOptionsShemeL[AppTheme.colorSelected].onPrimary,
      ),
      onPressed: () {
        setState(() {
          AppTheme.useLightMode = !AppTheme.useLightMode;
          actualizarTema();
          widget.accionx();
        });
      },
      tooltip: "Alternar tema",
    );
  }

  Widget _buildMaterialVersionToggleIcon() {
    return IconButton(
      icon: Icon(
        AppTheme.useMaterial3 ? Icons.filter_3 : Icons.filter_2,
        color: AppTheme.colorOptionsShemeL[AppTheme.colorSelected].onPrimary,
      ),
      onPressed: () {
        setState(() {
          AppTheme.useMaterial3 = !AppTheme.useMaterial3;
          actualizarTema();
          widget.accionx();
        });
      },
      tooltip: "Cambiar a Material ${AppTheme.useMaterial3 ? 2 : 3}",
    );
  }

  Widget _buildColorSelectionMenu() {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: AppTheme.colorOptionsShemeL[AppTheme.colorSelected].onPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (index) {
        setState(() {
          AppTheme.colorSelected = index;
          actualizarTema();
          widget.accionx();
        });
      },
      itemBuilder: (context) {
        return List.generate(AppTheme.colorTextLD.length, (index) {
          return PopupMenuItem(
            value: index,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    index == AppTheme.colorSelected
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: AppTheme.colorOptionsLD[index],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(AppTheme.colorTextLD[index]),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void actualizarTema() {
    if (AppTheme.useLightMode) {
      AppTheme.themeDataLight = ThemeData(
        useMaterial3: AppTheme.useMaterial3,
        colorScheme: AppTheme.colorOptionsShemeL[AppTheme.colorSelected],
      );
      AppTheme.colorMenu = const Color(0xFF3A5160);
      if (!AppTheme.useMaterial3) {
        AppTheme.colorMenu = const Color(0xFFFEFEFE);
      }
    } else {
      AppTheme.themeDataDark = ThemeData(
        useMaterial3: AppTheme.useMaterial3,
        colorScheme: AppTheme.colorOptionsShemeD[AppTheme.colorSelected],
      );
      AppTheme.colorMenu = const Color(0xFFFEFEFE);
    }
  }
}
