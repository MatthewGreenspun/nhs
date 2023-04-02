import "package:flutter/material.dart";

class TutoringSubjectContainer extends StatelessWidget {
  final String subjectName;
  final List<String> allClasses;
  final Set<String> chosenClasses;
  final void Function(String) onSelect;
  const TutoringSubjectContainer(
      {super.key,
      required this.subjectName,
      required this.allClasses,
      required this.chosenClasses,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(children: [
        Text(
          subjectName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...allClasses
            .map(
              (className) => CheckboxListTile(
                  value: chosenClasses.contains(className),
                  title: Text(className),
                  onChanged: (_) {
                    onSelect(className);
                  }),
            )
            .toList()
      ]),
    );
  }
}
