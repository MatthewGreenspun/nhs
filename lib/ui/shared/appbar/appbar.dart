import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:firebase_auth/firebase_auth.dart";

class NHSAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NHSAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  State<NHSAppBar> createState() => _NHSAppBarState();
}

class _NHSAppBarState extends State<NHSAppBar> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return AppBar(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "National Honor Society",
          style: GoogleFonts.francoisOne(color: Colors.white),
        ),
        CircleAvatar(backgroundImage: NetworkImage(user.photoURL!))
      ]),
    );
  }
}
