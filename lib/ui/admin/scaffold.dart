import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nhs/services/admin_service.dart';
import 'package:nhs/ui/admin/create_opportunity/create_project.dart';
import 'package:nhs/ui/admin/home/home.dart';
import 'package:nhs/ui/admin/people/people.dart';
import 'package:nhs/ui/admin/settings/settings.dart';
import 'package:nhs/ui/shared/misc/appbar.dart';
import 'package:nhs/ui/shared/opportunity/opportunities.dart';
import 'package:nhs/utils/ui.dart';
import '../../models/admin.dart';

class AdminScaffold extends StatefulWidget {
  const AdminScaffold({super.key});

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  int _currentIndex = 0;
  Admin? admin;

  @override
  void initState() {
    AdminService.stream.listen((event) {
      setState(() {
        admin = event;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (admin == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    Widget page = const Placeholder();
    if (_currentIndex == 0) {
      page = AdminHome(admin: admin!);
    } else if (_currentIndex == 1) {
      page = const People();
    } else if (_currentIndex == 2) {
      page = Opportunities(
        admin: admin,
      );
    } else if (_currentIndex == 3) {
      page = AdminSettings(admin: admin);
    }
    return Scaffold(
      appBar: const NHSAppBar(),
      body: page,
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          selectedIndex: _currentIndex,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.people_outlined),
                selectedIcon: Icon(Icons.people),
                label: "People"),
            NavigationDestination(
                icon: Icon(Icons.workspace_premium_outlined),
                selectedIcon: Icon(Icons.workspace_premium),
                label: "Opportunities"),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: "Settings"),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 250,
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          final formKey = GlobalKey<FormBuilderState>();
                          showBottomSheetDialogue(
                              context: context,
                              child: CreateProject(formKey: formKey),
                              actionButton: TextButton(
                                  onPressed: () {
                                    AdminService.createProject(
                                            formKey.currentState!.fields)
                                        .then(
                                            (value) => Navigator.pop(context));
                                  },
                                  child: const Text("Save")));
                        },
                        child: ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.workspace_premium_outlined)),
                            title: Text(
                              "Project",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.room_service_outlined)),
                            title: Text(
                              "Service",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.school_outlined)),
                            title: Text(
                              "Tutoring",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ),
                    ]),
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
