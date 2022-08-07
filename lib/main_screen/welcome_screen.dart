import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/supplier_home.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Color> textColors = [
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.teal
  ];
  bool pressing = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText("WELCOME",
                    colors: textColors,
                    textStyle: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold, fontFamily: "Acme")),
                ColorizeAnimatedText("DUCKS STORE",
                    colors: textColors,
                    textStyle: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold, fontFamily: "Acme"))
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
            // const Text("Welcome",
            //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
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
                          AnimatedLogo(controller: _controller),
                          YellowButton(
                              label: "log In",
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "/supplier_screen");
                              },
                              width: 0.25),
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
                        child: YellowButton(
                            label: "log In",
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/customer_screen");
                            },
                            width: 0.25),
                      ),
                      YellowButton(
                          label: "Sign Up",
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/customer_signup");
                          },
                          width: 0.25),
                      AnimatedLogo(controller: _controller),
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
                      pressing == true
                          ? const CircularProgressIndicator()
                          : GoogleFacebookLogIn(
                              label: "Google",
                              onPressed: () async {
                                setState(() {
                                  pressing = true;
                                });
                                await FirebaseAuth.instance.signInAnonymously();
                                Navigator.pushReplacementNamed(context, '/customer_screen');
                              },
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

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) => Transform.rotate(
              angle: _controller.value * 2.0 * pi,
              child: child,
            ),
        child: const Image(image: AssetImage("images/inapp/logo.jpg")));
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
