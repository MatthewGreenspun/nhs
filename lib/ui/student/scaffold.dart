import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nhs/services/staff_student_service.dart';
import 'package:nhs/ui/shared/appbar/appbar.dart';
import 'package:nhs/ui/student/home/request_tutoring.dart';
import '../../models/index.dart';
import "./home/home.dart";
import "./settings/settings.dart";

class StudentScaffold extends StatefulWidget {
  const StudentScaffold({super.key});

  @override
  State<StudentScaffold> createState() => _StudentScaffoldState();
}

class _StudentScaffoldState extends State<StudentScaffold> {
  final _studentService = StudentService();
  late StreamSubscription _sub;
  Student? _student;
  int _currentIndex = 0;

  @override
  void initState() {
    _sub = _studentService.stream.listen((student) {
      setState(() {
        _student = student;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (_student == null) {
      page = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_currentIndex == 0) {
      page = StudentHome(
        student: _student,
      );
    } else {
      page = StudentSettings(student: _student);
    }
    return Scaffold(
      appBar: const NHSAppBar(),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => RequestTutoring(
                    student: _student!,
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
