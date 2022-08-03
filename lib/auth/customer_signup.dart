import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';

class CustomerRegister extends StatelessWidget {
  CustomerRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const AuthHeaderLabel(headerLabel: "Sign Up"),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.purpleAccent,
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            color: Colors.white,
                            onPressed: () {
                              print("camera");
                            },
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.photo),
                            color: Colors.white,
                            onPressed: () {
                              print("camera");
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: textFormDecoration.copyWith(
                      labelText: "full Name",
                      hintText: "Enter your full name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFormDecoration.copyWith(
                      labelText: "Email Adress",
                      hintText: "Enter your email",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: textFormDecoration.copyWith(
                      labelText: "Password",
                      hintText: "Enter your password",
                    ),
                  ),
                ),
                HaveAccount(
                  haveAccount: "already have an account ?",
                  actionLabel: "Sign in",
                  onPressed: () {},
                ),
                AuthMainButton(
                  mainButtonLabel: "Sign up",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
