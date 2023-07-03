import 'package:flutter/material.dart';
import "package:flutter_form_builder/flutter_form_builder.dart";
import 'package:nhs/ui/admin/create_opportunity/roles.dart';
import 'package:nhs/ui/shared/inc_dec_button/index.dart';

class CreateProject extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const CreateProject({super.key, required this.formKey});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: widget.formKey,
        child: Expanded(
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
                    widget.formKey.currentState!.fields['title']!.validate(),
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
                onChanged: (value) => widget
                    .formKey.currentState!.fields['description']!
                    .validate(),
                decoration: const InputDecoration(
                    label: Text("Description"),
                    prefixIcon: Icon(Icons.short_text_outlined))),
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
                  widget.formKey.currentState!.fields['date']!.validate(),
              decoration: const InputDecoration(
                label: Text("Date"),
                prefixIcon: Icon(Icons.calendar_month_outlined),
              ),
            ),
            FormBuilderField(
                name: "credits",
                initialValue: 1,
                builder: (field) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: Icon(Icons.workspace_premium_outlined),
                        ),
                        const Expanded(
                          child: Text("Credits per role"),
                        ),
                        IncDecButton(
                          initial: 1,
                          min: 0,
                          max: 100,
                          onChange: (value) {
                            field.didChange(value);
                          },
                        ),
                      ],
                    )),
            const Divider(),
            FormBuilderCheckbox(
                name: "allowMultiRole",
                initialValue: false,
                title: const Text("Allow volunteers to have multiple roles")),
            const Divider(),
            const Roles()
          ],
        )));
  }
}
