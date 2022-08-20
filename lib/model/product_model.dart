import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/product_details.dart';
import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  late var wish = context.read<Wish>();
  late var getItem = wish.getWhisItems;
  late var item = getItem.firstWhereOrNull(
    (element) => element!.documentId == widget.products["proid"],
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productList: widget.products,
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
                    child: Image(image: NetworkImage(widget.products["proimage"][0])),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      widget.products['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products['price'].toStringAsFixed(2) + " \$",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                        widget.products["sid"] == FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  item != null
                                      ? context.read<Wish>().removeThis(widget.products["proid"])
                                      : context.read<Wish>().addWishItem(
                                          widget.products["productname"],
                                          widget.products["price"],
                                          1,
                                          widget.products["instock"],
                                          widget.products["proimage"],
                                          widget.products["proid"],
                                          widget.products["sid"]);
                                },
                                icon: context.watch<Wish>().getWhisItems.firstWhereOrNull(
                                            ((element) =>
                                                element!.documentId == widget.products["proid"])) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.red,
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
