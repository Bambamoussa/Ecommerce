import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/main_screen/category.dart';
import 'package:multi_store_app/main_screen/home.dart';
import 'package:multi_store_app/main_screen/profile.dart';
import 'package:multi_store_app/main_screen/store.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class CustomHomeScreen extends StatefulWidget {
  const CustomHomeScreen({super.key});

  @override
  State<CustomHomeScreen> createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoreScreen(),
    const CartScreen(),
    ProfileScreen(
      documentId: FirebaseAuth.instance.currentUser!.uid,
    )
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
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search), label: "Category"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.shop), label: "Store"),
            BottomNavigationBarItem(
                icon: badges.Badge(
                    showBadge:
                        context.watch<Cart>().getItems.isEmpty ? false : true,
                    badgeStyle: const BadgeStyle(
                      badgeColor: Colors.yellow,
                    ),
                    badgeContent: Text(
                      context.read<Cart>().getItems.length.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    badgeAnimation: const BadgeAnimation.scale(),
                    child: const Icon(Icons.shopping_cart)),
                label: "Cart"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profil"),
          ]),
    );
  }
}
