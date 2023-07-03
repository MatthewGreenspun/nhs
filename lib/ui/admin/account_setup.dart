import 'package:flutter/material.dart';
import 'package:nhs/services/admin_service.dart';

class AdminAccountSetup extends StatefulWidget {
  const AdminAccountSetup({super.key});

  @override
  State<AdminAccountSetup> createState() => _AdminAccountSetupState();
}

class _AdminAccountSetupState extends State<AdminAccountSetup> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text = "NHS";
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void onSubmit() {
    setState(() {
      _isLoading = true;
    });
    AdminService.createAdmin(name: _nameController.value.text)
        .then((value) => Navigator.pushReplacementNamed(context, "admin/home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Setup Your Account",
                style: TextStyle(fontSize: 25),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(label: Text("Name")),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                  onPressed: _isLoading ? null : onSubmit,
                  child: const Text("Finish"))
            ],
          ),
        ),
      ),
    );
  }
}
