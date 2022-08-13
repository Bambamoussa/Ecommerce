import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/auth_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  XFile? _imageFile;
  dynamic _pickImageError;
  final ImagePicker _imagePicker = ImagePicker();
  CollectionReference Suppliers = FirebaseFirestore.instance.collection('Suppliers');
  void _pickerImageCamera() async {
    try {
      final pickerImage = await _imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imageFile = pickerImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  void _pickerImageGallery() async {
    try {
      final pickerImage = await _imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300, imageQuality: 95);
      setState(() {
        _imageFile = pickerImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late String storeName;
  late String email;
  late String password;
  late String storeLogo;
  late String _uid;
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
                  children: <Widget>[
                    const AuthHeaderLabel(headerLabel: "Sign Up"),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage:
                                  _imageFile == null ? null : FileImage(File(_imageFile!.path))),
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
                                  _pickerImageCamera();
                                  print("object");
                                },
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.photo),
                                color: Colors.white,
                                onPressed: () {
                                  _pickerImageGallery();
                                  print("object");
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
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        }),
                        onChanged: (value) {
                          storeName = value;
                        },
                        decoration: textFormDecoration.copyWith(
                          labelText: "full Name",
                          hintText: "Enter your full name",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
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
                        onChanged: (value) {
                          email = value;
                        },
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
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        }),
                        onChanged: (value) {
                          password = value;
                        },
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
                    HaveAccount(
                      haveAccount: "already have an account ?",
                      actionLabel: "Sign In",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/supplier_login');
                      },
                    ),
                    processing == true
                        ? const CircularProgressIndicator()
                        : AuthMainButton(
                            mainButtonLabel: "Sign up",
                            onPressed: () {
                              signUp();
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

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          var ref = FirebaseStorage.instance.ref("supplier-images/${_emailController.text}.jpg");
          await ref.putFile(File(_imageFile!.path));
          storeLogo = await ref.getDownloadURL();
          _uid = FirebaseAuth.instance.currentUser!.uid;
          await Suppliers.doc(_uid).set({
            'storename': storeName,
            'email': email,
            'storelogo': storeLogo,
            'coverimage': '',
            'phone': '',
            'cid': _uid
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });

          Navigator.pushReplacementNamed(context, "/supplier_login");
          setState(() {
            processing = false;
          });
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MessengerHandler.showSnackBar(_scaffoldKey, "The password provided is too weak.");
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MessengerHandler.showSnackBar(
                _scaffoldKey, "The account already exists for that email.");
          }
        }
      } else {
        setState(() {
          processing = false;
        });

        MessengerHandler.showSnackBar(_scaffoldKey, "Please pick image fields");
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
