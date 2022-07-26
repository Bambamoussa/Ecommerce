import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow, width: 1.4),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Text(
                  "what are you looking for",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Container(
              height: 32,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(25)),
              child: const Center(
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
