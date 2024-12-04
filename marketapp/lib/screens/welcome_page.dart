import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketapp/languages/en_constant.dart';
import 'package:marketapp/screens/loading_screen.dart';
import 'package:marketapp/widgets/main_button.dart';
import 'package:marketapp/widgets/signup_button.dart';

class WelcomePage extends StatefulWidget {
  static const String id = "welcome_page";
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final Map<String, dynamic> selectedLanguage = en;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = "";
  String password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _handleLogin() async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')));
      await Future.delayed(const Duration(milliseconds: 500));
      // Navigate to the home page or dashboard after login.
      Navigator.pushNamed(context, LoadingScreen.id);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An unknown error occurred')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(8.0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${selectedLanguage['AppBarTitle']}!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.green[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.green),
                        ),
                        onChanged: (value) => email = value,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.green[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.green),
                        ),
                        onChanged: (value) => password = value,
                      ),
                      const SizedBox(height: 20),
                      MainButton(
                        text: "Login",
                        onPress: () async {
                          await _handleLogin();
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Or",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const SignUpButton(
                        icon: Icons.apple,
                        label: "Sign Up with Apple",
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      const SignUpButton(
                        icon: Icons.email,
                        label: "Sign Up with Google",
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
