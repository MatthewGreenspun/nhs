import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "../../../models/index.dart";

class MembersSignedUp extends StatelessWidget {
  final String opportunityId;
  const MembersSignedUp({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("opportunities")
            .doc(opportunityId)
            .collection("membersSignedUp")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      snapshot.data!.docs.isEmpty
                          ? "No one signed up"
                          : "NHS Members",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    )),
                Expanded(
                    child: ListView(
                  children: ListTile.divideTiles(
                      color: Theme.of(context).colorScheme.primary,
                      context: context,
                      tiles: snapshot.data!.docs.map((doc) {
                        final member = MemberSnippet.fromJson(doc.data());
                        return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(member.profilePicture),
                            ),
                            title: Text(member.name),
                            subtitle: Text(member.email));
                      })).toList(),
                ))
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
              children: const [Icon(Icons.error), Text("An Error Occurred")]);
        });
  }
}
