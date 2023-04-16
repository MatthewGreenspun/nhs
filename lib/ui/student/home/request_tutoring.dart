import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nhs/services/staff_student_service.dart';
import '../../../models/index.dart';
import "../../shared/constants.dart";

class RequestTutoring extends StatefulWidget {
  final Student student;
  const RequestTutoring({super.key, required this.student});

  @override
  State<RequestTutoring> createState() => _RequestTutoringState();
}

class _RequestTutoringState extends State<RequestTutoring> {
  final _studentService = StudentService();
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _subjects = kTutoringSubjects.values
      .toList()
      .fold([], (previousValue, element) => [...previousValue, ...element]);
  // TODO: allow student to choose a spefic NHS Member
  bool _isSelectingMember = false;

  Future onSubmit() async {
    _studentService.requestTutoring(
      subject: _formKey.currentState!.fields['subject']!.value as String,
      creatorName: widget.student.name,
      description:
          _formKey.currentState!.fields['description']!.value as String,
      period: _formKey.currentState!.fields['period']!.value as int,
      date: _formKey.currentState!.fields['date']!.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: FormBuilder(
            key: _formKey,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onSubmit().then((value) => Navigator.pop(context));
                        }
                      },
                      child: const Text("Save")),
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  FormBuilderField<String>(
                    name: "subject",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Subject is required";
                      } else if (!_subjects.contains(value)) {
                        return "Select a subject from the menu";
                      }
                      return null;
                    },
                    builder: (FormFieldState field) {
                      return Autocomplete<String>(
                        fieldViewBuilder: (context, textEditingController,
                                focusNode, onFieldSubmitted) =>
                            TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                              label: const Text("Subject"),
                              errorText: field.errorText,
                              prefixIcon: const Icon(Icons.subject)),
                          onChanged: (value) => field.didChange(value),
                          onFieldSubmitted: (value) => onFieldSubmitted(),
                        ),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _subjects.where((String subject) {
                            return subject
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          field.didChange(selection);
                        },
                      );
                    },
                  ),
                  FormBuilderTextField(
                      name: "description",
                      minLines: 1,
                      maxLines: 30,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "description is required";
                        }
                        return null;
                      },
                      onChanged: (value) => _formKey
                          .currentState!.fields['description']!
                          .validate(),
                      decoration: const InputDecoration(
                          label: Text("What do you need help with? "),
                          prefixIcon: Icon(Icons.help_center_outlined))),
                  FormBuilderDateTimePicker(
                    inputType: InputType.date,
                    name: "date",
                    initialValue: DateTime.now().add(const Duration(days: 1)),
                    validator: (value) {
                      if (value == null) {
                        return "Date is required";
                      }
                      if (value.isBefore(DateTime.now())) {
                        return "Date must be in the future";
                      }
                      if (value.weekday == DateTime.sunday ||
                          value.weekday == DateTime.saturday) {
                        return "Must be a weekday";
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        _formKey.currentState!.fields['date']!.validate(),
                    decoration: const InputDecoration(
                      label: Text("Date"),
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  FormBuilderDropdown(
                    name: "period",
                    initialValue: 1,
                    decoration: const InputDecoration(
                        label: Text("Period"),
                        prefixIcon: Icon(Icons.alarm_outlined)),
                    items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text("Period ${index + 1}"),
                            )),
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: _isSelectingMember,
                          onChanged: (value) {
                            setState(() {
                              _isSelectingMember = value!;
                            });
                          }),
                      const Text("Choose a specific NHS Member")
                    ],
                  ),
                  _isSelectingMember
                      ? FormBuilderTextField(
                          name: "member",
                          onChanged: (value) => _formKey
                              .currentState!.fields['member']!
                              .validate(),
                          decoration: const InputDecoration(
                            label: Text("NHS Member"),
                            prefixIcon: Icon(Icons.search),
                          ),
                        )
                      : Container(),
                ],
              )),
            ])));
  }
}
