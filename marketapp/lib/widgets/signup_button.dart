
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key,required this.icon,required this.label, this.color=Colors.black});

  final IconData icon;
  final String label;
  final Color color; 

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: const BorderSide(color: Colors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon( icon, color: color),
      label:  Text(label,
          style: TextStyle(color:color)),
      onPressed: () {},
    );
  }
}
