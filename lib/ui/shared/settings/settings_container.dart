import "package:flutter/material.dart";

class SettingsContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isEditable;
  final Function()? onEdit;
  const SettingsContainer(
      {super.key,
      this.title = "",
      required this.child,
      this.isEditable = false,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              isEditable
                  ? IconButton(onPressed: onEdit, icon: const Icon(Icons.edit))
                  : Container()
            ],
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border:
                      Border.all(color: Theme.of(context).hintColor, width: 3)),
              child: child)
        ]));
  }
}
