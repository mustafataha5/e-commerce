import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketapp/screens/login_screen_jwt.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key,required this.switchScreen});

  final Function switchScreen;
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final List<String> _bottomNavLabels;

  late FlutterSecureStorage storage;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  void initState() {
    super.initState();
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  void logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'uesrId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenJwt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
              onPressed: () {
                logout();
              },
              child: const Text("Logout"))
        ],
      ),
    );
  }
}
