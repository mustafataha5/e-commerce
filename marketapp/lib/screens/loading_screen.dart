import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketapp/data/category_list.dart';
import 'package:marketapp/screens/main_screen.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = "loading_screen";

  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late CategoryList categoryList ; // Declare categoryList here
  @override
  void initState() {
    super.initState();
    // categoryList = CategoryList();
    getMainScreen();
  }

  
   void getMainScreen() async {
    // Wait for 2 seconds before navigating to the MainScreen
    await Future.delayed(const Duration(milliseconds: 200));
     final categoryList = CategoryList();
     await categoryList.fetchCategories(); // Fetch categories

    // Navigate to MainScreen with categoryList
    Navigator.pushReplacementNamed(context, MainScreen.id) ; 
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => MainScreen(categoryList: categoryList),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Colors.greenAccent, // Main wave color
          size: 100.0, // Size of the wave
        ),
      ),
    );
  }
}
