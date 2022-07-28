import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SubCategoryProducts extends StatelessWidget {
  final String subCategName;
  final String mainCategName;
  const SubCategoryProducts({required this.subCategName, required this.mainCategName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            subCategName,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(mainCategName),
      ),
    );
  }
}
