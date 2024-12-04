import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketapp/screens/main_screen.dart';

class LoginScreenJwt extends StatefulWidget {
  static const String id = "Login_Screen_Jwt";
  const LoginScreenJwt({super.key});

  @override
  State<LoginScreenJwt> createState() => _LoginScreenJwtState();
}

class _LoginScreenJwtState extends State<LoginScreenJwt> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  late FlutterSecureStorage storage;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  void initState() {
    super.initState();
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.17:8001/api/mobilelogin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //print(response.body);
     // await storage.write(key: 'jwt', value: data['usertoken']);
      await storage.write(key: 'accessToken', value: data['accessToken']);
       await storage.write(key: 'userId', value: data['userId']);
      //print("JWT login ${await storage.read(key: 'jwt')}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
      Navigator.pushReplacementNamed(context, MainScreen.id);
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }

    setState(() {
      isLoading = false;
    });

    // // Replace with actual JWT login logic
    // if (email == "test@mail.com" && password == "password123") {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Login successful!')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Invalid email or password')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login with JWT"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: const Text("Login"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
