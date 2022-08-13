import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/customer_login.dart';
import 'package:multi_store_app/auth/customer_signup.dart';
import 'package:multi_store_app/auth/supplier_login.dart';
import 'package:multi_store_app/auth/supplier_signup.dart';
import 'package:multi_store_app/main_screen/custom_home.dart';
import 'package:multi_store_app/main_screen/supplier_home.dart';
import 'package:multi_store_app/main_screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:const  WelcomeScreen(),
      initialRoute: "/welcome_screen",
      routes: {
        "/welcome_screen": (context) => const WelcomeScreen(),
        "/customer_screen": (context) => const CustomHomeScreen(),
        "/supplier_screen": (context) => const SupplierHomeScreen(),
        "/customer_signup": (context) => const CustomerRegister(),
        "/customer_login": (context) => CustomerLogin(),
        "/supplier_login": (context) => const SupplierLogin(),
        "/supplier_signup": (context) => const SupplierRegister(),
      },
    );
  }
}
