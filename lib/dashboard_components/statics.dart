import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({Key? key}) : super(key: key);

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  @override
  Widget build(BuildContext context) {
    
   return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: "Stactistics"),
        leading: const AppBarBackButton(),
        ),
    );
  }
}