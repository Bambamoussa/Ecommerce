import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/stripe_id.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  late double totalPrice = context.watch<Cart>().totalPrice;
  late double totalPaid = context.watch<Cart>().totalPrice + 10.0;
  int selectedValue = 1;
  late String orderId;

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: "please wait ...", progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(title: "Payment"),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      Text(totalPaid.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Order",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Text(totalPrice.toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("Shipping Coast",
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Text("10.0", style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ]),
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
                            child: Column(
                              children: [
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text("Cash on Delivery"),
                                  subtitle: const Text("Pay Cash at home"),
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text("Pay via Visa/ Master Card"),
                                  subtitle: Row(
                                    children: const [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.blue,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccVisa,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                                RadioListTile(
                                    value: 3,
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    title: const Text("Pay via Paypal"),
                                    subtitle: Row(
                                      children: const [
                                        Icon(FontAwesomeIcons.paypal, color: Colors.blue),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(FontAwesomeIcons.ccPaypal, color: Colors.blue),
                                      ],
                                    )),
                              ],
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
                        label: "CONFIRM ${totalPaid.toStringAsFixed(2)} \$",
                        onPressed: () async {
                          switch (selectedValue) {
                            case 1:
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 100),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("Pay at home ${totalPaid.toStringAsFixed(2)} \$",
                                                  style: const TextStyle(
                                                      fontSize: 20, fontWeight: FontWeight.bold)),
                                              YellowButton(
                                                  label: "CONFIRM",
                                                  onPressed: () async {
                                                    showProgress();
                                                    for (var item
                                                        in context.read<Cart>().getItems) {
                                                      CollectionReference collectionReference =
                                                          FirebaseFirestore.instance
                                                              .collection("orders");
                                                      orderId = const Uuid().v4();
                                                      await collectionReference.doc(orderId).set({
                                                        "cid": data["cid"],
                                                        "custname": data["custname"],
                                                        "email": data["email"],
                                                        "adress": data["adress"],
                                                        "phone": data["phone"],
                                                        "profileimage": data["profileimage"],
                                                        "sid": item.suppId,
                                                        "proname": item.name,
                                                        "proid": item.documentId,
                                                        "orderid": orderId,
                                                        "ordername": item.name,
                                                        "orderimage": item.imagesUrl.first,
                                                        "orderqty": item.qty,
                                                        "orderprice": item.price,
                                                        "deliverystatus": "preparing",
                                                        "deliverydate": "",
                                                        "orderdate": DateTime.now(),
                                                        "paymentstatus": "cash on delivery",
                                                        "orderreview": false
                                                      }).whenComplete(() async {
                                                        await FirebaseFirestore.instance
                                                            .runTransaction((transaction) async {
                                                          DocumentReference documentReference =
                                                              FirebaseFirestore.instance
                                                                  .collection("products")
                                                                  .doc(item.documentId);
                                                          DocumentSnapshot snapshot2 =
                                                              await transaction
                                                                  .get(documentReference);
                                                          transaction.update(documentReference, {
                                                            "instock":
                                                                snapshot2["instock"] - item.qty
                                                          });
                                                        });
                                                      });
                                                    }

                                                    context.read<Cart>().clearCart();
                                                    Navigator.popUntil(context,
                                                        ModalRoute.withName('/customer_screen'));
                                                  },
                                                  width: 0.8)
                                            ],
                                          ),
                                        ),
                                      ));

                              return;
                            case 2:
                              int payment = totalPaid.round();
                              int pay = payment * 100;
                              await makePayment(pay.toString(), data);
                              print("visa cart");
                              return;
                            case 3:
                              print("paypal cart");
                              return;
                          }
                        },
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Map<String, dynamic>? paymentData;

  Future<void> makePayment(String total, dynamic data) async {
    try {
      final paymentData = await createPaymentIntent(total);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentData["client_secret"],
              applePay: const PaymentSheetApplePay(
                merchantCountryCode: 'CIV',
              ),
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'CIV',
                testEnv: true,
              ),
              merchantDisplayName: "MOUSSA"));

      await displayPaymentSheet(paymentData!["client_secret"]);
      showProgress();
      for (var item in context.read<Cart>().getItems) {
        CollectionReference collectionReference = FirebaseFirestore.instance.collection("orders");
        orderId = const Uuid().v4();
        await collectionReference.doc(orderId).set({
          "cid": data["cid"],
          "custname": data["custname"],
          "email": data["email"],
          "adress": data["adress"],
          "phone": data["phone"],
          "profileimage": data["profileimage"],
          "sid": item.suppId,
          "proname": item.name,
          "proid": item.documentId,
          "orderid": orderId,
          "ordername": item.name,
          "orderimage": item.imagesUrl.first,
          "orderqty": item.qty,
          "orderprice": item.price,
          "deliverystatus": "preparing",
          "deliverydate": "",
          "orderdate": DateTime.now(),
          "paymentstatus": "paid online",
          "orderreview": false
        }).whenComplete(() async {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentReference documentReference =
                FirebaseFirestore.instance.collection("products").doc(item.documentId);
            DocumentSnapshot snapshot2 = await transaction.get(documentReference);
            transaction.update(documentReference, {"instock": snapshot2["instock"] - item.qty});
          });
        });
      }

      context.read<Cart>().clearCart();
      Navigator.popUntil(context, ModalRoute.withName('/customer_screen'));
    } catch (e) {
      print(e);
    }
  }

  createPaymentIntent(String total) async {
    Map<String, dynamic> body = {
      "amount": total,
      "currency": "USD",
      "payment_method_types[0]": "card",
    };
    final response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer $stripeSecretKey",
          "Content-Type": "application/x-www-form-urlencoded"
        });

    return jsonDecode(response.body);
  }

  displayPaymentSheet(clientSecret) async {
    try {
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(clientSecret: clientSecret, confirmPayment: true),
      );
    } catch (e) {
      print({"errrrrrrrrrrrrrrrrrrrr$e"});
    }
  }
}
