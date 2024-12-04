import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketapp/data/item.dart';
import 'package:marketapp/languages/ar_constant.dart';
import 'package:marketapp/languages/en_constant.dart';
import 'package:marketapp/screens/cart_screen.dart';
import 'package:marketapp/screens/category_screen.dart';
import 'package:marketapp/screens/items_screen.dart';
import 'package:marketapp/screens/login_screen_jwt.dart';
import 'package:marketapp/screens/order_screen.dart';
import 'package:marketapp/screens/user_screen.dart';
import 'package:marketapp/widgets/popup_info.dart';

class MainScreen extends StatefulWidget {
  static const String id = "main_screen";
  //final CategoryList? categoryList; // Accept CategoryList as a parameter

  //const MainScreen({super.key, this.categoryList});
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic> selectedLanguage = en;
  int _selectedIndex = 0;
  bool isArabic = false;
  late Widget currentScreen;
  List<Item> cart = [];
  // List for bottom navigation labels based on the selected language
  late final List<String> _bottomNavLabels;

  late FlutterSecureStorage storage;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  void initState() {
    super.initState();
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    _checkLoginStatus(); // Use an asynchronous method to handle login checks
    currentScreen = CategoryScreen(switchScreen: switchScreen);
    _updateBottomNavLabels();
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await isLoggedIn();
    if (!loggedIn) {
      // Navigate to the login page
      //print(" <<<<<< not logIn");
      Navigator.pushReplacementNamed(context, LoginScreenJwt.id);
    }
    else{
      //print(" >>>>>  logIn");
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await storage.read(key: 'accessToken');
    String? user = await storage.read(key: 'userId');
   // print("jwt >>> $token");
   // print("userId : $user");
    return token != null && token.isNotEmpty;
  }

  void _updateBottomNavLabels() {
    _bottomNavLabels = [
      selectedLanguage['MainLabel'] ?? 'Main',
      selectedLanguage['BasketLabel'] ?? 'Basket',
      selectedLanguage['OrdersLabel'] ?? 'Orders',
      selectedLanguage['AccountLabel'] ?? 'Account',
    ];
  }

  void _itemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      switchScreen(index: index);
    });
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupInfo(isArabic: isArabic);
      },
    );
  }

  void _switchLanguage(bool newbool) {
    setState(() {
      isArabic = newbool;
      selectedLanguage = isArabic ? ar : en;
      _updateBottomNavLabels(); // Update labels when switching languages
    });
  }

  void addToChart(Item item) {
    setState(() {
      cart.add(item);
    });
  }

  void removeFromCart(String id) {
    setState(() {
      cart.removeWhere((item) => item.itemId == id);
    });
  }

  void clearAllCart(){
    setState(() {
      cart.clear(); 
    });
  }

  void addQuantityToCart(String id) {
    setState(() {
      // Find the item in the chart with the given ID
      var item = cart.firstWhere((item) => item.itemId == id);
      //print("Adding 1 to ${id}");

      // Increment the quantity of the item
      item.quantity++;
      //print("Updated quantity: ${item.quantity}");
    });
  }

  void removeQuantityFromCart(String id) {
    setState(() {
      // Find the item in the chart with the given ID
      var item = cart.firstWhere((item) => item.itemId == id);
      //print("Removing 1 from ${id}");

      // Check if quantity is 1 before decrementing; if so, remove it from the chart
      if (item.quantity <= 1) {
        cart.remove(item);
        // print("${id} removed from chart");
      } else {
        // Otherwise, decrement the quantity
        item.quantity--;
        // print("Updated quantity: ${item.quantity}");
      }
    });
  }

  void switchScreen({int index = 0, String id = ""}) {
    setState(() {
      if (index == 0) {
        //_itemSelected(index);
        _selectedIndex = index;
        currentScreen = CategoryScreen(
          switchScreen: switchScreen,
        );
      } else if (index == 1) {
        //to chart screen
        currentScreen = CartScreen(
          initialCart: cart,
          addQuantityToCart: addQuantityToCart,
          removeQuantityFromCart: removeQuantityFromCart,
          removeFromCart: removeFromCart,
          switchScreen: switchScreen,
          clearAllCart: clearAllCart,
        );
      } else if (index == 2) {
        //to order screen
        currentScreen =  OrderScreen(switchScreen:switchScreen) ; 
      } else if (index == 3) {
        //to user screen
        currentScreen = UserScreen(
          switchScreen: switchScreen,
        );
      } else if (index == 4) {
        currentScreen = ItemsScreen(
          categoryId: id,
          chart: cart,
          addToChart: addToChart,
          addQuantityToChart: addQuantityToCart,
          removeQuantityFromChart: removeQuantityFromCart,
          isArabic: isArabic,
          switchScreen: switchScreen,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _showInfoDialog(context);
          },
          icon: const Icon(Icons.local_shipping, semanticLabel: 'Info'),
        ),
        title: Text(
          selectedLanguage['AppBarTitle'] ?? 'Welcome',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.greenAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              onChanged: (String? language) {
                setState(() {
                  if (language == 'En') {
                    _switchLanguage(false);
                  } else if (language == 'Ar') {
                    _switchLanguage(true);
                  }
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'En',
                  child: Text('Eng'),
                ),
                DropdownMenuItem(
                  value: 'Ar',
                  child: Text('Ar'),
                ),
              ],
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              underline: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _bottomNavLabels[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_basket),
            label: _bottomNavLabels[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: _bottomNavLabels[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _bottomNavLabels[3],
          ),
        ],
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _itemSelected,
      ),
    );
  }
}
