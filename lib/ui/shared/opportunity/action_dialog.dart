import "package:flutter/material.dart";

class ActionDialog extends StatelessWidget {
  final void Function() onEdit;
  final void Function() onDelete;
  const ActionDialog({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ListTile.divideTiles(
                  color: Theme.of(context).dividerColor,
                  context: context,
                  tiles: [
                    _ActionButton(
                      name: "Edit",
                      onTap: onEdit,
                      color: Colors.blue,
                      icon: Icons.edit,
                    ),
                    _ActionButton(
                      name: "Delete",
                      onTap: onDelete,
                      color: Colors.red,
                      icon: Icons.delete,
                    ),
                  ]).toList())),
    );
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
        splashColor: color.withAlpha(50),
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            color: color,
            size: 30,
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 20, color: color),
          ),
        ));
  }
}
