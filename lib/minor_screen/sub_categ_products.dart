import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class SubCategoryProducts extends StatelessWidget {
  final String subCategName;
  final String mainCategName;
  const SubCategoryProducts({required this.subCategName, required this.mainCategName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: AppBarTitle(title: subCategName),
        leading:const  AppBarBackButton(),
      ),
      body: Center(
        child: Text(mainCategName),
      ),
    );
  }
}

