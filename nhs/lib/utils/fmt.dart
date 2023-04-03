String fmtDays(List<String> days) {
  const dayOrder = {
    "Monday": 0,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
  };
  days.sort((d1, d2) => dayOrder[d1]! - dayOrder[d2]!);
  final list = days.fold("",
      (previousValue, element) => "$previousValue, ${element.substring(0, 3)}");
  return list.substring(1); //remove first comma
}

String fmtCredits(double num) {
  if (num.roundToDouble() == num) return num.toInt().toString();
  return num.toString();
}

String fmtSemester() {
  final now = DateTime.now();
  final year = now.year;
  if (now.month > 1 && now.month < 9) return "Spring $year";
  return "Fall $year";
}
