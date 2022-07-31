import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("images/inapp/bgimage.jpg"), fit: BoxFit.cover),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Welcome",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(
              height: 120,
              width: 200,
              child: Image(image: AssetImage("images/inapp/logo.jpg")),
            ),
            const Text("Shop",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
                      child: const Text("Suppliers only",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: const BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Image(image: AssetImage("images/inapp/logo.jpg")),
                          YellowButton(label: "log In", onPressed: () {}, width: 0.25),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: YellowButton(label: "Sign Up", onPressed: () {}, width: 0.25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: YellowButton(label: "log In", onPressed: () {}, width: 0.25),
                      ),
                      YellowButton(label: "Sign Up", onPressed: () {}, width: 0.25),
                      const Image(image: AssetImage("images/inapp/logo.jpg")),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                  height: 90,
                  decoration: const BoxDecoration(color: Colors.white38),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleFacebookLogIn(
                        label: "Google",
                        onPressed: () {},
                        child: const Image(image: AssetImage("images/inapp/google.jpg")),
                      ),
                      GoogleFacebookLogIn(
                        label: "Facebook",
                        onPressed: () {},
                        child: const Image(image: AssetImage("images/inapp/facebook.jpg")),
                      ),
                      GoogleFacebookLogIn(
                        label: "Google",
                        onPressed: () {},
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }
}

class GoogleFacebookLogIn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogIn({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
