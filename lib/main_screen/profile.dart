import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            expandedHeight: 140,
            flexibleSpace: LayoutBuilder(
              builder: ((context, constraints) => FlexibleSpaceBar(
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: constraints.biggest.height <= 120 ? 1 : 0,
                      child: const Text("Account",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    background: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.yellow, Colors.brown]))),
                  )),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(children: [
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                        child: TextButton(
                          onPressed: () {},
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
                          onPressed: () {},
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
                                topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
                        child: TextButton(
                          onPressed: () {},
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
                    children: const [
                      RepeatListTitle(
                        title: "Email Adress",
                        subtitle: "exemple@gmail.com",
                        icon: Icons.email,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 1,
                        ),
                      ),
                      RepeatListTitle(
                          title: "Phone Number", subtitle: "+1 2356789", icon: Icons.phone),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 1,
                        ),
                      ),
                      RepeatListTitle(
                          title: "Address",
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
                          title: "Edit profil", subtitle: "", icon: Icons.edit, onPressed: () {}),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 1,
                        ),
                      ),
                      RepeatListTitle(
                          title: "Phone Number", subtitle: "", icon: Icons.phone, onPressed: () {}),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Divider(
                          color: Colors.yellow,
                          thickness: 1,
                        ),
                      ),
                      RepeatListTitle(
                          title: "Address",
                          subtitle: "",
                          icon: Icons.location_on,
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class RepeatListTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function? onPressed;
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
      onTap: () {},
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
