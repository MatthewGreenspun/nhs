import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:nhs/utils/fmt.dart";
import "package:uuid/uuid.dart";
import "../../../models/index.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

class RequestService extends StatefulWidget {
  final Staff staff;
  const RequestService({super.key, required this.staff});

  @override
  State<RequestService> createState() => _RequestServiceState();
}

class _RequestServiceState extends State<RequestService> {
  final _user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormBuilderState>();

  Future onSubmit() async {
    final period = _formKey.currentState!.fields['period']!.value as int;
    final DateTime date =
        fmtDate(_formKey.currentState!.fields['date']!.value, period);
    final title = _formKey.currentState!.fields['title']!.value as String;
    final opportunity = Opportunity(
        creatorId: _user.uid,
        creatorName: widget.staff.name,
        department: widget.staff.department,
        opportunityType: OpportunityType.service,
        credits: 1,
        description:
            _formKey.currentState!.fields['description']!.value as String,
        membersNeeded: int.parse(
            _formKey.currentState!.fields['membersNeeded']!.value as String),
        membersSignedUp: [],
        date: date,
        period: period,
        title: title);
    return FirebaseFirestore.instance
        .collection("opportunities")
        .doc(opportunity.id)
        .set(opportunity.toJson())
        .then((_) {
      final snippetId = const Uuid().v4();
      final snippet = ServiceSnippet(
          id: snippetId,
          opportunityId: opportunity.id,
          period: period,
          date: date,
          title: title);
      FirebaseFirestore.instance
          .collection("users")
          .doc(_user.uid)
          .collection("posts")
          .doc(snippetId)
          .set(snippet.toJson());
    });
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
                  FormBuilderTextField(
                      name: "title",
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          _formKey.currentState!.fields['title']!.validate(),
                      decoration: const InputDecoration(
                          label: Text("Title"),
                          prefixIcon: Icon(Icons.title_outlined))),
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
                          prefixIcon: Icon(Icons.description_outlined))),
                  FormBuilderTextField(
                    name: "membersNeeded",
                    keyboardType: TextInputType.number,
                    initialValue: "1",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Number of members is required";
                      }
                      return null;
                    },
                    onChanged: (value) => _formKey
                        .currentState!.fields['membersNeeded']!
                        .validate(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people_outline),
                      label: Text("How many students do you need?"),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
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
                  )
                ],
              )),
            ])));
  }
}
