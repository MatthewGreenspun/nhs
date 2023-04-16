import "package:flutter/material.dart";

class ActionDialog extends StatelessWidget {
  final void Function() onEdit;
  final void Function() onDelete;
  const ActionDialog({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Actions",
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(bottom: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionButton(
              name: "Edit",
              onTap: onEdit,
              color: Colors.indigo,
              icon: Icons.edit,
            ),
            _ActionButton(
              name: "Delete",
              onTap: onDelete,
              color: Colors.red,
              icon: Icons.delete,
            ),
          ],
        ));
  }
}

class _ActionButton extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;
  final void Function() onTap;
  const _ActionButton(
      {super.key,
      required this.name,
      required this.icon,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.indigo.withAlpha(50),
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 20, color: color),
                  ),
                )
              ],
            )));
  }
}
