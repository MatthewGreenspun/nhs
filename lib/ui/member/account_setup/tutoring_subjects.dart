import "package:flutter/material.dart";
import "package:nhs/ui/member/account_setup/tutoring_subject_container.dart";
import "../../../models/index.dart";

//TODO: load from firebase
const kTutoringSubjects = {
  "Math": [
    "Algebra I",
    "Geometry",
    "H. Geometry",
    "Algebra II/Trig",
    "H. Algebra II/Trig",
    "Precalculus",
    "H. Precalculus",
    "Calculus",
    "AP Calculus AB",
    "AP Calculus BC",
    "AP Computer Science",
    "Statistics",
    "AP Statistics",
  ],
  "Science": [
    "Biology",
    "H. Biology",
    "AP Biology",
    "Post-AP Genetics",
    "Chemistry",
    "H. Chemistry",
    "AP Chemistry",
    "Physics",
    "AP Physics I",
    "AP Physics II",
    "AP Physics C",
    "AP Psychology",
  ],
  "Social Studies": [
    "Global History 9",
    "Global History 10",
    "AP World History",
    "AP European History",
    "AP Human Geography",
    "US History",
    "AP US History",
    "US Government and Politics",
    "AP US Government with Economics",
    "AP Comparative Government",
    "AP Microeconomics",
    "AP Macroeconomics",
    "AP Economics w/ Gov (Mic/Mac)",
  ],
  "English": [
    "English 9",
    "English 10",
    "English 11",
    "Journalism",
    "AP English Language and Composition",
    "English 12",
    "AP English Literature Creative Writing",
    "AP English Literature Traditions",
  ],
  "Languages": [
    "Chinese 1",
    "Chinese 2",
    "Chinese 3",
    "AP Chinese",
    "Spanish 1",
    "Spanish 2",
    "Spanish 3",
    "AP Spanish",
    "French 1",
    "French 2",
    "French 3",
    "AP French",
    "Latin 1",
    "Latin 2",
    "Latin 3",
    "AP Latin",
    "Japanese 1",
    "Japanese 2",
    "Japanese 3",
    "AP Japanese",
  ],
  "Other": [
    "Time Management Help",
    "SAT Prep",
    "ACT Prep",
  ]
};

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
