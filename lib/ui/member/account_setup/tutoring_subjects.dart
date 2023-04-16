import "package:flutter/material.dart";
import "package:nhs/ui/member/account_setup/tutoring_subject_container.dart";
import "../../../models/index.dart";
import "../../shared/constants.dart";

class TutoringSubjects extends StatefulWidget {
  final Member member;
  final PageController pageController;
  const TutoringSubjects(
      {super.key, required this.member, required this.pageController});

  @override
  State<TutoringSubjects> createState() => _TutoringSubjectsState();
}

class _TutoringSubjectsState extends State<TutoringSubjects> {
  final Set<String> _chosenClasses = {};

  void onSelect(String className) {
    setState(() {
      if (_chosenClasses.contains(className)) {
        _chosenClasses.remove(className);
      } else {
        _chosenClasses.add(className);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const Text(
          "Choose Tutoring Subjects",
          style: TextStyle(fontSize: 25),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: kTutoringSubjects.entries
                .map((entry) => TutoringSubjectContainer(
                    subjectName: entry.key,
                    allClasses: entry.value,
                    chosenClasses: _chosenClasses,
                    onSelect: onSelect))
                .toList(),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              widget.member.tutoringSubjects = _chosenClasses.toList();
              widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut);
            },
            child: const Text("   Continue   "))
      ],
    ));
  }
}
