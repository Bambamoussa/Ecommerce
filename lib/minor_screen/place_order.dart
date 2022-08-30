import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customers_screen/add_address.dart';
import 'package:multi_store_app/customers_screen/address_book.dart';
import 'package:multi_store_app/minor_screen/payment_screen.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where("default", isEqualTo: true)
      .limit(1)
      .snapshots();
  late String name;
  late String phone;
  late String address;

  late double totalPrice = context.watch<Cart>().totalPrice;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          /*  if (snapshot.data!.docs.isEmpty) {
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
          }*/
          return Material(
            color: Colors.grey.shade200,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade200,
                  leading: const AppBarBackButton(),
                  title: const AppBarTitle(title: "Place Order"),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                  child: Column(
                    children: [
                      snapshot.data!.docs.isEmpty
                          ? InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AddAddress()));
                              },
                              child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                    child: Text(
                                      "set your Address",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Acme",
                                          color: Colors.blue,
                                          letterSpacing: 1.5),
                                    ),
                                  )),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AddressBook()));
                              },
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          var customer = snapshot.data!.docs[index];
                                          name =
                                              "${customer["firstname"]}  ${customer["lastname"]}";
                                          phone = customer["phone"];
                                          address =
                                              "${customer["country"]} ${customer["state"]} ${customer["city"]}";

                                          return ListTile(
                                            title: SizedBox(
                                              height: 50,
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${customer['firstname']} - ${customer['lastname']}'),
                                                    Text(customer['phone'])
                                                  ]),
                                            ),
                                            subtitle: SizedBox(
                                              height: 70,
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'city/state: ${customer['city']} ${customer['state']}'),
                                                    Text('country:     ${customer['country']} ')
                                                  ]),
                                            ),
                                          );
                                        })

                                    /*Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: []),*/
                                    ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Consumer<Cart>(
                            builder: (BuildContext context, Cart cart, _) {
                              return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: (BuildContext context, int index) {
                                  final orders = cart.getItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 0.3),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                              orders.imagesUrl.first,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(orders.name,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey.shade600)),
                                                  Row(
                                                    children: [
                                                      Text(orders.price.toStringAsFixed(2),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey.shade600)),
                                                      Text("x ${orders.qty}",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey.shade600)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: YellowButton(
                      label: "CONFIRM ${totalPrice.toStringAsFixed(2)} \$",
                      onPressed: snapshot.data!.docs.isEmpty
                          ? () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddAddress()));
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                            name: name,
                                            phone: phone,
                                            address: address,
                                          )));
                            },
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
