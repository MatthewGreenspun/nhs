import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../../models/student.dart";

class StudentAccountSetup extends StatefulWidget {
  const StudentAccountSetup({super.key});

  @override
  State<StudentAccountSetup> createState() => _StudentAccountSetupState();
}

class _StudentAccountSetupState extends State<StudentAccountSetup> {
  late TextEditingController _nameController;
  late FocusNode _nameNode;
  late TextEditingController _graduationYearController;
  late FocusNode _graduationYearNode;
  bool _isLoading = false;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser!;
    _nameController = TextEditingController();
    _nameController.text = user.displayName!;
    _nameNode = FocusNode();
    _graduationYearController = TextEditingController();
    _graduationYearController.text = DateTime.now().year.toString();
    _graduationYearNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const margin = 8.0;
    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: const EdgeInsets.all(margin),
          child: Column(
            children: [
              const Text(
                "Setup Your Account",
                style: TextStyle(fontSize: 25),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: margin, vertical: margin * 2),
                child: TextFormField(
                  focusNode: _nameNode,
                  controller: _nameController,
                  decoration: const InputDecoration(label: Text("Name")),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: margin, vertical: margin * 2),
                child: TextFormField(
                  focusNode: _graduationYearNode,
                  controller: _graduationYearController,
                  decoration:
                      const InputDecoration(label: Text("Graduation Year")),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          final user = FirebaseAuth.instance.currentUser!;
                          _nameNode.unfocus();
                          _graduationYearNode.unfocus();
                          final student = Student(
                              name: _nameController.text,
                              email: user.email!,
                              graduationYear:
                                  int.parse(_graduationYearController.text));
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.uid)
                              .set(student.toJson())
                              .then((value) {
                            Navigator.pushReplacementNamed(
                                context, "student/home");
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                  child: const Text("   Finish Setup   "))
            ],
          )),
    ));
  }
}
