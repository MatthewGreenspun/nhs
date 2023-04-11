import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../models/index.dart";
import "../../shared/opportunity/opportunity_page.dart";

class StudentHome extends StatelessWidget {
  final Student? student;
  const StudentHome({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    if (student == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (student!.posts.isEmpty) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
            Text(
              "No Posts",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text("Request a tutor below")
          ]));
    }
    return ListView.builder(
        itemCount: student!.posts.length,
        itemBuilder: ((context, index) {
          final post = student!.posts[index];
          return Dismissible(
              background: const Card(
                  child: ListTile(
                tileColor: Colors.indigo,
                title: Text(
                  "AAAAAA",
                  style: TextStyle(color: Colors.indigo),
                ),
                subtitle: Text(
                  "AAAAAA",
                  style: TextStyle(color: Colors.indigo),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.edit_outlined),
                ),
              )),
              secondaryBackground: const Card(
                  child: ListTile(
                tileColor: Colors.red,
                title: Text(
                  "AAAAAA",
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                  "AAAAAA",
                  style: TextStyle(color: Colors.red),
                ),
                trailing: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.delete_outline),
                ),
              )),
              onDismissed: (direction) {
                if (direction.name == "startToEnd") {
                  //edit
                  return;
                }
                final removedSnippet = student!.posts.removeAt(index);
                FirebaseFirestore.instance
                    .collection("opportunities")
                    .doc(removedSnippet.opportunityId)
                    .delete();
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .set({
                  "posts": FieldValue.arrayRemove([removedSnippet.toJson()])
                }, SetOptions(merge: true));
              },
              key: Key(post.title),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OpportunityPage(id: post.opportunityId)));
                  },
                  child: ListTile(
                    title: Text(post.title),
                    leading: const CircleAvatar(
                        child: Icon(Icons.workspace_premium_outlined)),
                    subtitle: Text(DateFormat.MMMMEEEEd().format(post.date)),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  )));
        }));
  }
}
