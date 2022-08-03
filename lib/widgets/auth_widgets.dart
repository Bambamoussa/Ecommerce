import 'package:flutter/material.dart';

var textFormDecoration = InputDecoration(
  labelText: 'full Name',
  hintText: "Enter your full name",
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purpleAccent, width: 1),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purpleAccent, width: 1),
    borderRadius: BorderRadius.circular(15),
  ),
);

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final Function() onPressed;
  const AuthMainButton({
    Key? key,
    required this.mainButtonLabel,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child: Text(mainButtonLabel,
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;
  const HaveAccount({
    Key? key,
    required this.haveAccount,
    required this.actionLabel,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(haveAccount, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
        TextButton(
            onPressed: onPressed,
            child: Text(actionLabel,
                style: const TextStyle(
                    fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const AuthHeaderLabel({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/welcome_screen');
            },
            icon: const Icon(Icons.home_work),
          ),
        ],
      ),
    );
  }
}
