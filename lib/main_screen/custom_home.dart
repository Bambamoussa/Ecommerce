import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/main_screen/category.dart';
import 'package:multi_store_app/main_screen/home.dart';
import 'package:multi_store_app/main_screen/profile.dart';
import 'package:multi_store_app/main_screen/store.dart';

class CustomHomeScreen extends StatefulWidget {
  const CustomHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomHomeScreen> createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    CartScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Category"),
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Store"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ]),
    );
  }
}
