import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nhs/ui/shared/appbar/appbar.dart';
import '../../models/index.dart';
import "./home/home.dart";
import "./settings/settings.dart";

class StudentScaffold extends StatefulWidget {
  const StudentScaffold({super.key});

  @override
  State<StudentScaffold> createState() => _StudentScaffoldState();
}

class _StudentScaffoldState extends State<StudentScaffold> {
  final _user = FirebaseAuth.instance.currentUser!;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late StreamSubscription _sub;
  Student? _student;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .snapshots();
    _sub = _stream.listen((event) {
      event.reference.collection("posts").limit(5).snapshots().listen(
        (postEvent) {
          print("new post event: $event");
          if (_student == null) return;
          setState(() {
            _student!.posts = postEvent.docs
                .map((postDoc) => ServiceSnippet.fromJson(postDoc.data()))
                .toList();
          });
        },
      );
      print("new staff event: $event");
      setState(() {
        _student = Student.fromJson(event.data()!);
      });
    });

    super.initState();
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
