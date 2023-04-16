import "package:flutter/material.dart";

class NoResults extends StatelessWidget {
  final String title;
  final String subtitle;
  final Icon? icon;
  const NoResults(
      {super.key, required this.title, required this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      icon ?? Container(),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      Text(subtitle)
    ]));
  }
}
