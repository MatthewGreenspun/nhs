import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../../models/index.dart";

class BasicInfo extends StatefulWidget {
  final Member member;
  final PageController pageController;
  const BasicInfo(
      {super.key, required this.member, required this.pageController});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  late TextEditingController _nameController;
  late TextEditingController _graduationYearController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text = widget.member.name;
    _graduationYearController = TextEditingController();
    _graduationYearController.text = widget.member.graduationYear.toString();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Text(
                  "Setup Your Account",
                  style: TextStyle(fontSize: 25),
                ),
                Container(
                    margin: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _nameController,
                      onChanged: (value) {
                        widget.member.name = value;
                      },
                      decoration: const InputDecoration(
                        label: Text("Name"),
                      ),
                    )),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _graduationYearController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            widget.member.graduationYear = int.parse(value);
                          },
                          decoration: const InputDecoration(
                              label: Text("Graduation Year")),
                        ))),
                ElevatedButton(
                  onPressed: () {
                    widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                  },
                  child: const Text("   Continue   "),
                )
              ],
            )));
  }
}
