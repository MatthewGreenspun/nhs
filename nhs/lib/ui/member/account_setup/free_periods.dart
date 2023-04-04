import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../../../models/index.dart";

// First element is an empty string for formatting purposes
const kDaysOfTheWeek = [
  "",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday"
];

class FreePeriods extends StatefulWidget {
  final Member member;
  const FreePeriods({super.key, required this.member});

  @override
  State<FreePeriods> createState() => _FreePeriodsState();
}

class _FreePeriodsState extends State<FreePeriods> {
  bool _isLoading = false;
  Map<int, List<String>> freePeriods = {};

  void onSelect(int period, String day, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (freePeriods.containsKey(period)) {
          freePeriods[period]!.add(day);
        } else {
          freePeriods[period] = [day];
        }
      } else {
        freePeriods[period]?.remove(day);
        if (freePeriods.containsKey(period) && freePeriods[period]!.isEmpty) {
          freePeriods.remove(period);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      const Text(
        "Select Your Free Periods",
        style: TextStyle(fontSize: 25),
      ),
      Expanded(
          child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    //Header row
                    children: kDaysOfTheWeek
                        .map(
                          (day) => Expanded(
                            child: Text(
                              day.length > 3 ? day.substring(0, 3) : "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ...List.generate(
                      10,
                      (rowIndex) => Row(children: [
                            Expanded(child: Text("Period ${rowIndex + 1}")),
                            ...List.generate(
                                5,
                                (index) => Expanded(
                                    child: Checkbox(
                                        value: freePeriods
                                                .containsKey(rowIndex + 1) &&
                                            freePeriods[rowIndex + 1]!.contains(
                                                kDaysOfTheWeek[index + 1]),
                                        onChanged: (value) => onSelect(
                                            rowIndex + 1,
                                            kDaysOfTheWeek[index + 1],
                                            value!))))
                          ]))
                ],
              ))),
      ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  widget.member.freePeriods = freePeriods;
                  final user = FirebaseAuth.instance.currentUser!;

                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .set(widget.member.toJson())
                      .then((value) {
                    setState(() {
                      _isLoading = true;
                    });
                    Navigator.pushReplacementNamed(context, "member/home");
                  });
                },
          child: const Text("Finish Setup"))
    ]));
  }
}
