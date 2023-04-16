import "package:flutter/material.dart";
import "package:nhs/services/staff_student_service.dart";
import "../../shared/constants.dart";

class StaffAccountSetup extends StatefulWidget {
  const StaffAccountSetup({super.key});

  @override
  State<StaffAccountSetup> createState() => _StaffAccountSetupState();
}

class _StaffAccountSetupState extends State<StaffAccountSetup> {
  final _staffService = StaffService();
  late TextEditingController _nameController;
  late TextEditingController _departmentController;
  late FocusNode _node;
  bool _isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _departmentController = TextEditingController();
    _nameController.text = _staffService.user.displayName!;
    _node = FocusNode();
    super.initState();
  }

  void onSubmit() {
    setState(() {
      _isLoading = true;
    });
    _node.unfocus();
    _staffService
        .createStaff(
            name: _nameController.text, department: _departmentController.text)
        .then((value) {
      Navigator.pushReplacementNamed(context, "staff/home");
      setState(() {
        _isLoading = false;
      });
    });
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
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  onPressed: _isLoading ? null : onSubmit,
                  child: const Text("   Finish Setup   "))
            ],
          )),
    ));
  }
}
