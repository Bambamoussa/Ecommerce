import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  XFile? _imageFile;

  CollectionReference Suppliers = FirebaseFirestore.instance.collection('Suppliers');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool processing = false;
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AuthHeaderLabel(headerLabel: "Log In"),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _emailController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          } else if (value.isValidEmail() == false) {
                            return "Please enter a valid email";
                          } else if (value.isValidEmail() == true) {
                            return null;
                          }
                          return null;
                        }),
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
                        controller: _passwordController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        }),
                        obscureText: passwordVisible,
                        decoration: textFormDecoration.copyWith(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                            color: Colors.purple,
                          ),
                          labelText: "Password",
                          hintText: "Enter your password",
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                        )),
                    HaveAccount(
                      haveAccount: "Don\'t Have An Account ?",
                      actionLabel: "Sign up",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/Supplier_signup');
                      },
                    ),
                    processing == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.purple,
                          ))
                        : AuthMainButton(
                            mainButtonLabel: "Log In",
                            onPressed: () {
                              logIn();
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        _formKey.currentState!.reset();

        Navigator.pushReplacementNamed(context, "/supplier_screen");
        setState(() {
          processing = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MessengerHandler.showSnackBar(_scaffoldKey, "No user found for that email.");
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MessengerHandler.showSnackBar(_scaffoldKey, "Wrong password provided for that user.");
        }
      }
    } else {
      setState(() {
        processing = false;
      });
      MessengerHandler.showSnackBar(_scaffoldKey, "Please fill all the fields");
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}
