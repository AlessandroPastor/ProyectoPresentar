import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final String label;

  const Button({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          child: ElevatedButton(
            onPressed: () {
              onTap();
            },
            child: Text(
              label!,
              style: TextStyle(fontSize: 20),
            ),
          )

          /*ElevatedButton(
            style: ElevatedButton.styleFrom(
              //onPrimary: Theme.of(context).colorScheme.onSecondary,
              //primary: Theme.of(context).colorScheme.secondary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: () {onTap(); },
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),*/
        )
      ),
    );
  }
}