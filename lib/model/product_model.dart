import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/product_details.dart';

class ProductModel extends StatelessWidget {
  final dynamic products;
  const ProductModel({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productList: products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 250, minHeight: 150),
                    child: Image(image: NetworkImage(products["proimage"][0])),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      products['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products['price'].toStringAsFixed(2) + " \$",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            products["sid"] == FirebaseAuth.instance.currentUser!.uid
                                ? Icons.edit
                                : Icons.favorite_border_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
