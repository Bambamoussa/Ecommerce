import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customers_screen/customer_orders.dart';
import 'package:multi_store_app/customers_screen/whislist.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  CollectionReference customers = FirebaseFirestore.instance.collection('customers');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return //Text("Full Name: ${data['full_name']} ${data['last_name']}");
              Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.yellow, Colors.brown]),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      elevation: 0,
                      pinned: true,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace: LayoutBuilder(
                        builder: ((context, constraints) => FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: constraints.biggest.height <= 120 ? 1 : 0,
                                child: const Text("Account",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              background: Container(
                                decoration: const BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: [Colors.yellow, Colors.brown])),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30, top: 25),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(data["profileImage"]),
                                        radius: 50,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(data["name"].toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 24, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30))),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CartScreen(
                                              backButton: AppBarBackButton(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: const Center(
                                          child: Text(
                                            "Cart",
                                            style: TextStyle(fontSize: 20, color: Colors.yellow),
                                          ),
                                        ),
                                      ),
                                    )),
                                Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.yellow,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const CustomerOrders(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: const Center(
                                          child: Text(
                                            "Orders",
                                            style: TextStyle(fontSize: 20, color: Colors.black54),
                                          ),
                                        ),
                                      ),
                                    )),
                                Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const WhisListScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: const Center(
                                          child: Text(
                                            "wishlist",
                                            style: TextStyle(fontSize: 20, color: Colors.yellow),
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(children: [
                              const SizedBox(
                                height: 150,
                                child: Image(image: AssetImage("images/inapp/logo.jpg")),
                              ),
                              const ProfileHeader(headerLabel: " Account Info."),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    children: [
                                      RepeatListTitle(
                                        title: data["email"],
                                        subtitle: "exemple@gmail.com",
                                        icon: Icons.email,
                                      ),
                                      const YellowDivider(),
                                      RepeatListTitle(
                                          title: data["phone"],
                                          subtitle: "+1 2356789",
                                          icon: Icons.phone),
                                      const YellowDivider(),
                                      RepeatListTitle(
                                          title: data["address"],
                                          subtitle: "70 rue du luxembourg",
                                          icon: Icons.location_on),
                                    ],
                                  ),
                                ),
                              ),
                              const ProfileHeader(headerLabel: " Account Settings "),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    children: [
                                      RepeatListTitle(
                                          title: "Edit profil",
                                          subtitle: "",
                                          icon: Icons.edit,
                                          onPressed: () {}),
                                      const YellowDivider(),
                                      RepeatListTitle(
                                          title: "change Password",
                                          subtitle: "",
                                          icon: Icons.lock,
                                          onPressed: () {}),
                                      const YellowDivider(),
                                      RepeatListTitle(
                                          title: "log out",
                                          subtitle: "",
                                          icon: Icons.logout,
                                          onPressed: () async {
                                            MyAlertDialog.showDialog(
                                                context: context,
                                                title: "Log out",
                                                content: "Are you sure you want to log out?",
                                                tabNo: () {
                                                  Navigator.pop(context);
                                                },
                                                tabYes: () async {
                                                  await FirebaseAuth.instance.signOut();
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacementNamed(
                                                      context, "/welcome_screen");
                                                });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(
            child: CircularProgressIndicator(
          color: Colors.purple,
        ));
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatListTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatListTitle({
    Key? key,
    required this.title,
    this.subtitle = "",
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String headerLabel;
  const ProfileHeader({
    Key? key,
    required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          Text(headerLabel,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
