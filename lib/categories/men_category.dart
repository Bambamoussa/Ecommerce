import 'package:flutter/material.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(36.0),
          child: Text(
            "Men",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 70,
            crossAxisSpacing: 15,
            children: List.generate(
              4,
              (index) => Column(children: [
                SizedBox(
                  height: 70,
                  width: 40,
                  child: Image(image: AssetImage('images/men/men$index.jpg')),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
