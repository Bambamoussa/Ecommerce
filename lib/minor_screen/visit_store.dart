import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/minor_screen/edit_store.dart';
import 'package:multi_store_app/model/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({Key? key, required this.suppId}) : super(key: key);

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  ValueNotifier<bool> following = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    CollectionReference supplier = FirebaseFirestore.instance.collection('Suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: supplier.doc(widget.suppId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              leading: const yellowBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data['storelogo'],
                          fit: BoxFit.cover,
                        )),
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(data['storename'].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                            )),
                        data["cid"] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(width: 4, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: ValueListenableBuilder(
                                  valueListenable: following,
                                  builder: (context, value, child) {
                                    return MaterialButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => EditStore(
                                                        data: data,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: const [
                                            Text(
                                              "Edit",
                                              style: TextStyle(color: Colors.black, fontSize: 16),
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ));
                                  },
                                )),
                              )
                            : Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(width: 4, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: ValueListenableBuilder(
                                  valueListenable: following,
                                  builder: (context, value, child) {
                                    return MaterialButton(
                                      onPressed: () {
                                        following.value = !(following.value);
                                      },
                                      child: following.value == true
                                          ? const Text(
                                              "Following",
                                              style: TextStyle(color: Colors.black, fontSize: 16),
                                            )
                                          : const Text(
                                              "Follow",
                                              style: TextStyle(color: Colors.black, fontSize: 16),
                                            ),
                                    );
                                  },
                                )),
                              )
                      ],
                    ),
                  )
                ],
              ),
              toolbarHeight: 100,
              flexibleSpace: data["coverimage"] == ""
                  ? Image.asset(
                      "images/inapp/coverimage.jpg",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data["coverimage"],
                      fit: BoxFit.cover,
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
                      'this store \n \n ahs is no items yet',
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 48,
              ),
              onPressed: () {},
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
