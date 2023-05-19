import "package:flutter/material.dart";
import "package:nhs/models/index.dart";
import "package:nhs/services/member_service.dart";
import "../../shared/constants.dart";
import "../account_setup/tutoring_subject_container.dart";

class EditTutoringSubjects extends StatefulWidget {
  final Member member;
  const EditTutoringSubjects({super.key, required this.member});

  @override
  State<EditTutoringSubjects> createState() => _EditTutoringSubjectsState();
}

class _EditTutoringSubjectsState extends State<EditTutoringSubjects> {
  late Set<String> _tutoringSubjects;
  @override
  void initState() {
    _tutoringSubjects = Set.from(widget.member.tutoringSubjects);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    MemberService.editTutoringSubjects(_tutoringSubjects);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: kTutoringSubjects.entries
                .map((entry) => TutoringSubjectContainer(
                    subjectName: entry.key,
                    allClasses: entry.value,
                    chosenClasses: _tutoringSubjects,
                    onSelect: (subject) {
                      setState(() {
                        if (_tutoringSubjects.contains(subject)) {
                          _tutoringSubjects.remove(subject);
                        } else {
                          _tutoringSubjects.add(subject);
                        }
                      });
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }
}
