import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../../../models/staff.dart";

const kDepartments = [
  "Art",
  "Biology",
  "English",
  "Mathematics and Computer Science",
  "Music",
  "Physical Science and Engineering",
  "Social Studies",
  "World Languages",
  "Physical Education",
  "Administration",
  "Custodial",
  "Guidance",
  "School Aides",
  "Secretaries",
  "Security",
  "Technology",
];

class StaffAccountSetup extends StatefulWidget {
  const StaffAccountSetup({super.key});

  @override
  State<StaffAccountSetup> createState() => _StaffAccountSetupState();
}

class _StaffAccountSetupState extends State<StaffAccountSetup> {
  final staff = Staff(name: "", email: "", department: "");
  late TextEditingController _nameController;
  late TextEditingController _departmentController;
  late FocusNode _node;
  bool _isLoading = false;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser!;
    staff.name = user.displayName!;
    staff.email = user.email!;
    _nameController = TextEditingController();
    _departmentController = TextEditingController();
    _nameController.text = staff.name;
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const margin = 8.0;
    final dropdownMenuWidth = MediaQuery.of(context).size.width - 4 * margin;
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
                  focusNode: _node,
                  controller: _nameController,
                  onChanged: (value) => staff.name = value,
                  decoration: const InputDecoration(label: Text("Name")),
                ),
              ),
              DropdownMenu<String>(
                width: dropdownMenuWidth,
                initialSelection: kDepartments.first,
                controller: _departmentController,
                label: const Text('Department'),
                dropdownMenuEntries: kDepartments
                    .map((department) => DropdownMenuEntry(
                          value: department,
                          label: department,
                        ))
                    .toList(),
                onSelected: (String? value) {
                  setState(() {
                    staff.department = value!;
                  });
                },
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
                          _node.unfocus();
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(user.uid)
                              .set(staff.toJson())
                              .then((value) {
                            Navigator.pushReplacementNamed(
                                context, "staff/home");
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
