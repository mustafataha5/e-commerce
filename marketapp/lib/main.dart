
import 'package:flutter/material.dart';
import 'package:marketapp/screens/entry_screen.dart';
import 'package:marketapp/screens/login_screen_jwt.dart';
// import 'package:marketapp/screens/items_screen.dart';
import 'package:marketapp/screens/main_screen.dart';
import 'package:marketapp/screens/order_screen.dart';
// import 'package:marketapp/screens/loading_screen.dart';
import 'package:marketapp/screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async {
   // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainScreen.id,
      //initialRoute: LoginScreenJwt.id,
      routes: {
        EntryScreen.id : (context) => const EntryScreen(),
        LoginScreenJwt.id: (context) => const LoginScreenJwt(),
       // LoadingScreen.id : (context) => const LoadingScreen(),
        MainScreen.id : (context) => const MainScreen(),
        WelcomePage.id :(context) => const WelcomePage() ,
       // OrderScreen.id : (context) => const OrderScreen() ,
        //ItemsScreen.id: (context) => const ItemsScreen() ,
         
      },
    );
  }
}
