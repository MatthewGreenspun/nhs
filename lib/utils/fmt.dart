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

/// Re-formats date to include the correct time based on the period
/// times taken from https://bxscience.edu/apps/pages/index.jsp?uREC_ID=219380&type=d&termREC_ID=&pREC_ID=439502&hideMenu=0
DateTime fmtDate(DateTime date, int period) {
  const standardSchedule = {
    1: [8, 5],
    2: [8, 51],
    3: [9, 37],
    4: [10, 25],
    5: [11, 11],
    6: [11, 57],
    7: [12, 43],
    8: [13, 29],
    9: [14, 15],
    10: [15, 01],
  };
  const thursdaySchedule = {
    1: [8, 6],
    2: [8, 50],
    3: [9, 37],
    4: [10, 33],
    5: [11, 17],
    6: [12, 1],
    7: [12, 45],
    8: [13, 29],
    9: [14, 13],
    10: [14, 57],
  };
  if (date.day == DateTime.thursday) {
    final times = thursdaySchedule[period]!;
    return date.copyWith(hour: times[0], minute: times[1]).toUtc();
  }
  final times = standardSchedule[period]!;
  return date.copyWith(hour: times[0], minute: times[1]).toUtc();
}
