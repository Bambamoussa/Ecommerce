import 'package:flutter/material.dart';

class CustomerOrderModel extends StatelessWidget {
  final dynamic orders;
  const CustomerOrderModel({Key? key, required this.orders}) : super(key: key);

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
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(("\$") + (orders["orderprice"].toStringAsFixed(2))),
                        Text(" x  ${orders["orderqty"].toString()}",
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
            children: [const Text("See More ..."), Text(orders["deliverystatus"])],
          ),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: orders["deliverystatus"] == "delivered"
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.yellow.withOpacity(0.2),
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
                          style: const TextStyle(fontSize: 15, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Delivery status: }",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "  ${orders["deliverystatus"]}",
                          style: const TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                    orders["deliverystatus"] == "shipping"
                        ? Text(
                            " Estimated Delivery Date: ${orders["deliverydate"]}",
                            style: const TextStyle(fontSize: 15),
                          )
                        : const Text(""),
                    orders["deliverystatus"] == "delivered" && orders["orderreview"] == false
                        ? TextButton(
                            onPressed: () {},
                            child: const Text("Write a review",
                                style: TextStyle(
                                  fontSize: 15,
                                )))
                        : const Text(""),
                    orders["deliverystatus"] == "delivered" && orders["orderreview"] == true
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
