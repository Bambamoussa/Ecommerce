import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/minor_screen/full_screen.dart';
import 'package:multi_store_app/minor_screen/visit_store.dart';
import 'package:multi_store_app/model/product_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:collection/collection.dart';
import 'package:multi_store_app/providers/wihs_provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailsScreen({Key? key, this.productList}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<dynamic> imageList = widget.productList["proimage"];
  late var wish = context.read<Wish>();
  late var getItem = wish.getWhisItems;
  late var item = getItem.firstWhereOrNull(
    (element) => element!.documentId == widget.productList["proid"],
  );
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    var onSale = widget.productList['discount'];

    String calculPrice() {
      var calcul = (1 - (widget.productList["discount"] / 100)) * widget.productList["price"];
      return calcul.toStringAsFixed(2);
    }

    final getItemexist = context.read<Cart>().getItems.firstWhereOrNull(
          (element) => element!.documentId == widget.productList["proid"],
        );

    final Stream<QuerySnapshot> _productListStream = FirebaseFirestore.instance
        .collection('productList')
        .where("maintecategory", isEqualTo: widget.productList["maintecategory"])
        .where("subcategory", isEqualTo: widget.productList["subcategory"])
        .snapshots();
    ValueNotifier buttonIcon = ValueNotifier(null);

    return Material(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imagesList: imageList,
                                  )));
                    },
                    child: Stack(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                            pagination: const SwiperPagination(builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(image: NetworkImage(imageList[index]));
                            },
                            itemCount: imageList.length),
                      ),
                      Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                      Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(Icons.share),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.productList['productname'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "USD ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    widget.productList['price'].toStringAsFixed(2),
                                    style: onSale != 0
                                        ? const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough)
                                        : const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  onSale != 0
                                      ? Text(
                                          calculPrice(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red),
                                        )
                                      : const Text(" ")
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            buttonIcon.value = item;
                            item != null
                                ? context.read<Wish>().removeThis(widget.productList["proid"])
                                : context.read<Wish>().addWishItem(
                                    widget.productList["productname"],
                                    onSale != 0
                                        ? onSale != 0
                                            ? (1 - (widget.productList["discount"] / 100)) *
                                                widget.productList["price"]
                                            : widget.productList["price"]
                                        : widget.productList["price"],
                                    1,
                                    widget.productList["instock"],
                                    widget.productList["proimage"],
                                    widget.productList["proid"],
                                    widget.productList["sid"]);
                          },
                          icon: ValueListenableBuilder(
                            valueListenable: buttonIcon,
                            builder: (context, value, child) {
                              if (value != null) {
                                return const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red,
                                );
                              } else {
                                return const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                );
                              }
                            },
                          ))
                    ],
                  ),
                  widget.productList["instock"] == 0
                      ? const Text(
                          "this item is out of stock",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : Text(
                          "${widget.productList["instock"]} pieces available in stock ",
                          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                  const ProductDetailsHeader(
                    label: "  Item Description  ",
                  ),
                  Text(
                    widget.productList['productdescription'],
                    textScaleFactor: 1.1,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                  ),
                  const ProductDetailsHeader(
                    label: "  Similar Items  ",
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productListStream,
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
                  )
                ],
              ),
            ),
            bottomSheet: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitStore(
                                      suppId: widget.productList["sid"],
                                    )));
                      },
                      icon: const Icon(Icons.store)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartScreen(
                                      backButton: AppBarBackButton(),
                                    )));
                      },
                      icon: Badge(
                          showBadge: context.watch<Cart>().getItems.isEmpty ? false : true,
                          padding: const EdgeInsets.all(2),
                          badgeColor: Colors.yellow,
                          badgeContent: Text(
                            context.read<Cart>().getItems.length.toString(),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          animationType: BadgeAnimationType.scale,
                          child: const Icon(Icons.shopping_cart))),
                  YellowButton(
                      label: "ADD TO CART",
                      onPressed: () {
                        if (widget.productList["instock"] == 0) {
                          MessengerHandler.showSnackBar(
                              _scaffoldKey, " the Product is out in stock ");
                        } else if (getItemexist != null) {
                          MessengerHandler.showSnackBar(_scaffoldKey, "Product already in cart");
                        } else {
                          context.read<Cart>().addItem(
                              widget.productList["productname"],
                              onSale != 0
                                  ? (1 - (widget.productList["discount"] / 100)) *
                                      widget.productList["price"]
                                  : widget.productList["price"],
                              1,
                              widget.productList["instock"],
                              widget.productList["proimage"],
                              widget.productList["proid"],
                              widget.productList["sid"]);
                        }
                      },
                      width: 0.5)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  final String label;
  const ProductDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(label,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow.shade900)),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
