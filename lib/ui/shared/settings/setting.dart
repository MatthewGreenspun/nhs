import "package:flutter/material.dart";

class Setting extends StatelessWidget {
  final String name;
  final Widget child;
  const Setting({
    super.key,
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16),
          ),
          child
        ]));
  }
}
