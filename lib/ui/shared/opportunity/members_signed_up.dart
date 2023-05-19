import "package:flutter/material.dart";
import "../../../models/index.dart";

class MembersSignedUp extends StatelessWidget {
  final List<MemberSnippet> members;
  const MembersSignedUp({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              members.isEmpty ? "No one signed up" : "NHS Members",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
        Expanded(
            child: ListView(
          children: ListTile.divideTiles(
              color: Theme.of(context).colorScheme.primary,
              context: context,
              tiles: members.map((member) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.profilePicture),
                  ),
                  title: Text(member.name),
                  subtitle: Text(member.email),
                );
              })).toList(),
        ))
      ],
    );
  }
}