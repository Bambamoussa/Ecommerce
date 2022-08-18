import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/category.dart';
import 'package:multi_store_app/main_screen/dashboard.dart';
import 'package:multi_store_app/main_screen/home.dart';
import 'package:multi_store_app/main_screen/store.dart';
import 'package:multi_store_app/main_screen/upload_product.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    DashBoardScreen(),
    UploadProductScreen(),
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DashBoard"),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          ]),
    );
  }
}
