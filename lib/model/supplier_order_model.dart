import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import "package:intl/intl.dart";

class SupplierOrderModel extends StatelessWidget {
  final dynamic orders;
  const SupplierOrderModel({super.key, required this.orders});

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
            constraints:
                const BoxConstraints(maxHeight: 80, maxWidth: double.infinity),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(orders["orderimage"]),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orders["proname"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(("\$") +
                                (orders["orderprice"].toStringAsFixed(2))),
                            Text(" x  ${orders["orderqty"].toString()}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600))
                          ]),
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("See More ..."),
              Text(orders["deliverystatus"])
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${orders["custname"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Phone number: ${orders["phone"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Email Adress: ${orders["email"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Adress: ${orders["adress"]}",
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: [
                        const Text(
                          "payment Status: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          " ${orders["paymentstatus"]}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.purple),
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
                          "  ${orders["deliverystatus"]}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Order date: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          DateFormat("yyyy-MM-dd")
                              .format(orders["orderdate"].toDate())
                              .toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    orders["deliverystatus"] == "delivered"
                        ? const Text(
                            "This product has been delivery",
                            style: TextStyle(color: Colors.green),
                          )
                        : Row(
                            children: [
                              const Text(
                                "Change Delivery Status To: ",
                                style: TextStyle(fontSize: 15),
                              ),
                              orders["deliverystatus"] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now().add(
                                              const Duration(days: 365),
                                            ), onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(orders["orderid"])
                                              .update({
                                            "deliverystatus": "shipping",
                                            "deliverydate": date
                                          });
                                        });
                                      },
                                      child: const Text("shipping ?"))
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("orders")
                                            .doc(orders["orderid"])
                                            .update({
                                          "deliverystatus": "delivered",
                                        });
                                      },
                                      child: const Text("delivery ?"))
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
  }
}
