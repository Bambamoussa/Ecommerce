import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import "package:intl/intl.dart";
import 'package:multi_store_app/widgets/yellow_button.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic orders;
  const CustomerOrderModel({Key? key, required this.orders}) : super(key: key);

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comments;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80, maxWidth: double.infinity),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.orders["orderimage"]),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orders["proname"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(("\$") + (widget.orders["orderprice"].toStringAsFixed(2))),
                        Text(" x  ${widget.orders["orderqty"].toString()}",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
                      ]),
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("See More ..."), Text(widget.orders["deliverystatus"])],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.orders["deliverystatus"] == "delivered"
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${widget.orders["custname"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Phone number: ${widget.orders["phone"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Email Adress: ${widget.orders["email"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Adress: ${widget.orders["adress"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Text(
                          "payment Status: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          " ${widget.orders["paymentstatus"]}",
                          style: const TextStyle(fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Delivery status: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "  ${widget.orders["deliverystatus"]}",
                          style: const TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.orders["deliverystatus"] == "shipping"
                        ? Text(
                            " Estimated Delivery Date: ${DateFormat("yyyy-MM-dd").format(widget.orders["orderdate"].toDate()).toString()}",
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(""),
                    widget.orders["deliverystatus"] == "delivered" &&
                            widget.orders["orderreview"] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) => Material(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 150),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              RatingBar.builder(
                                                  initialRating: 1,
                                                  minRating: 1,
                                                  allowHalfRating: true,
                                                  itemBuilder: (context, index) {
                                                    return const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    );
                                                  },
                                                  onRatingUpdate: (value) {
                                                    rate = value;
                                                  }),
                                              TextField(
                                                decoration: InputDecoration(
                                                    hintText: "Write your review here",
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(15)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey.shade300, width: 1)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                        borderSide: const BorderSide(
                                                            color: Colors.amber, width: 2))),
                                                onChanged: ((value) {
                                                  comments = value;
                                                }),
                                                maxLines: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  YellowButton(
                                                      label: "cancel",
                                                      onPressed: (() {
                                                        Navigator.pop(context);
                                                      }),
                                                      width: 0.3),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  YellowButton(
                                                      label: "OK",
                                                      onPressed: () async {
                                                        CollectionReference collectionReference =
                                                            FirebaseFirestore.instance
                                                                .collection("products")
                                                                .doc(widget.orders["proid"])
                                                                .collection("reviews");
                                                        await collectionReference
                                                            .doc(FirebaseAuth
                                                                .instance.currentUser!.uid)
                                                            .set({
                                                          "review": comments,
                                                          "rate": rate,
                                                          "name": widget.orders["custname"],
                                                          "email": widget.orders["email"],
                                                          "profileimage":
                                                              widget.orders["profileimage"],
                                                          "date": DateTime.now()
                                                        }).whenComplete(() async {
                                                          await FirebaseFirestore.instance
                                                              .runTransaction((transaction) async {
                                                            DocumentReference documentReference =
                                                                FirebaseFirestore.instance
                                                                    .collection("orders")
                                                                    .doc(widget.orders["orderid"]);
                                                            await transaction.update(
                                                                documentReference,
                                                                {"orderreview": true});
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      width: 0.3)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )));
                            },
                            child: const Text("Write a review",
                                style: TextStyle(
                                  fontSize: 15,
                                )))
                        : const Text(""),
                    widget.orders["deliverystatus"] == "delivered" &&
                            widget.orders["orderreview"] == true
                        ? Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                                size: 20,
                              ),
                              Text("Review Added",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic)),
                            ],
                          )
                        : const Text(" ")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
