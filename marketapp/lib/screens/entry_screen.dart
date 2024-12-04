import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:marketapp/languages/en_constant.dart';
import 'package:marketapp/screens/welcome_page.dart';

class EntryScreen extends StatefulWidget {
  static const String id = "entry_screen";
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final Map<String, dynamic> selectedLanguage = en;

  void routeToLogin() async {
    await Future.delayed(const Duration(seconds: 5));
    //Navigator.pushReplacementNamed(context, WelcomePage.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routeToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.greenAccent,
                  width: 4.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 8,
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              selectedLanguage['AppBarTitle'],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black38,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Your one-stop shop for everything you need!",
                    speed: const Duration(milliseconds: 70),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                isRepeatingAnimation: false, // Animates once
                onTap: () {
                  print("Title tapped!"); // Optional tap action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
