import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({super.key, this.icon, this.toDo});

  final IconData? icon;
  final Function? toDo;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 10,
      shape: const CircleBorder(),
      fillColor: const Color.fromARGB(255, 140, 147, 180),
      onPressed: () {
        if (toDo != null) {
          toDo!();
        }
      },
      
      constraints: const BoxConstraints(
        
        maxHeight: 56,
        minHeight: 30,
        minWidth: 30,
      ),
      child: Icon(icon),
    );
  }
}


