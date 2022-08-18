import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/model/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategoryProducts extends StatefulWidget {
  final String subCategName;
  final String mainCategName;
  const SubCategoryProducts({required this.subCategName, required this.mainCategName});

  @override
  State<SubCategoryProducts> createState() => _SubCategoryProductsState();
}

class _SubCategoryProductsState extends State<SubCategoryProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where("maintecategory", isEqualTo: widget.mainCategName)
        .where("subcategory", isEqualTo: widget.subCategName)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: const AppBarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(
          title: widget.subCategName,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'this category \n \n ahs is no items yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Acme",
                    letterSpacing: 1.5),
              ),
            );
          }

          return SingleChildScrollView(
            child: StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                crossAxisCount: 2,
                itemBuilder: ((context, index) {
                  return ProductModel(
                    products: snapshot.data!.docs[index],
                  );
                }),
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
        },
      ),
    );
  }
}
