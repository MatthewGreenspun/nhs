import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/utils/fmt.dart';

class Statistics extends StatelessWidget {
  final Admin admin;
  const Statistics({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            fmtSemester(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: CircleAvatar(
                    child: Text("10"),
                  )),
              Text("Project Service Average")
            ],
          ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: CircleAvatar(
                    child: Text("10"),
                  )),
              Text("Project Service Average")
            ],
          ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: CircleAvatar(
                    child: Text("10"),
                  )),
              Text("Project Service Average")
            ],
          ),
        ],
      ),
    );
  }
}
