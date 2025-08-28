import 'dart:math';

num? max(List<num> values) {
  if (values.isEmpty) {
    return null;
  }
  num max = -double.infinity;
  for (final value in values) {
    if (value > max) {
      max = value;
    }
  }
  return max;
}

num? min(List<num> values) {
  if (values.isEmpty) {
    return null;
  }
  num min = double.infinity;
  for (final value in values) {
    if (value < min) {
      min = value;
    }
  }
  return min;
}

// Function to return the number of days from the start of the year given a date. (DD/MM/YYYY)
int dateToInt(String date) {

  const Map<int, int> daysPerMonth = {
    1: 31,
    2: 28,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };

  RegExp dateRegEx = RegExp(r'[0-9]{1,2}[/-]+[0-9]{1,2}[/-]+[0-9]+');

  RegExpMatch? match = dateRegEx.firstMatch(date);

  if (match != null) {
    RegExp dayRegEx = RegExp(r'[0-9]{1,2}');
    Iterable<RegExpMatch> matches = dayRegEx.allMatches(match[0]!);

    List<String> matchValues = matches.take(2).map((match) => match.group(0)!).toList();

    int day = int.parse(matchValues[0]);
    int month = int.parse(matchValues[1]);

    // print(day);
    // print(month);

    while (month-1 > 0) {
      day += daysPerMonth[month-1]!;
      month--;
    }

    return day;

  } else {
    return 0;
  }
}

// Function to traslate from january to september (Maximum one year of difference)
int dateJanToSep (int num) {
  if (num - 243 >= 0) {
    return num - 243;
  }
  return num - 243 + 365;
}

// Function to convert single percs (x%) to double
double? percToDouble (String perc) {
  RegExp regEx = RegExp(r'[0-9]+%');

  RegExpMatch? match = regEx.firstMatch(perc);

  if (match != null) {
    try {
      return double.parse(match[0]!.split('%')[0]);
    } catch (e) {
      return null;
    }
  }
  
  return null;
}

// Mean given a list
double? mean(List<dynamic> nums) {

  if (nums.isEmpty || nums.any((element) => element == null)) {
    return null;
  }

  num s = 0;

  for (final n in nums) {
    s += n;
  }

  return (s / nums.length);
}

// Weighted mean given two lists
double? weightedMean(List<dynamic> nums, List<dynamic> weights) {

  if (nums.isEmpty || nums.any((element) => element == null)) {
    return null;
  }

  num s = 0;
  num ws = 0;

  for (var i = 0; i < nums.length; i++) {
    num w = weights[i] ?? 1;
    s += nums[i] * w;
    ws += w;
  }

  return (s / ws);
}

// Standard deviation of a set of numbers
double? standardDeviation(List<dynamic> nums) {

  if (nums.isEmpty || nums.any((element) => element == null)) {
    return null;
  }

  double? m = mean(nums);
  double sd = 0;

  for (final n in nums) {
    sd += pow((n-m), 2);
  }

  return sqrt(sd / nums.length);
}

// Get the occurencies of datas in a list
dynamic getDistribution(List<num> values) {
  Map<num, double> distribution = {};

  for (var i = 0; i < values.length; i++) {
    if (distribution.containsKey(values[i])) {
      distribution[values[i].toDouble()] = distribution[values[i]]! + 1;
      continue;
    }
    distribution[values[i].toDouble()] = 1;
  }

  return distribution;
}

// Get the occurencies of datas in a list, grouped by integer classes
dynamic getIntegerDistribution(List<num> values) {
  Map<num, double> distribution = {};

  for (var i = 0; i < values.length; i++) {
    if (distribution.containsKey(values[i].toInt())) {
      distribution[values[i].toInt()] = distribution[values[i].toInt()]! + 1;
      continue;
    }
    distribution[values[i].toInt()] = 1;
  }

  return distribution;
}

// Get the occurencies of datas in a list, grouped by dynamic classes
dynamic getClassesDistribution(List<num> values) {
  Map<num, double> distribution = {};

  if (values.isEmpty) {
    return const {};
  }

  final int N = (1 + 10 / 3 * log(values.length) / log(10)).ceil(); // 1 + (10/3) log_10(n), Number of classes
  final num rn = max(values)!; // MAX
  final num r0 = min(values)!;  // MIN

  final num r = rn - r0;
  final num l = r / N; // Width of a single class

  if (l == 0) {
    return const {};
  }

  for (var i = 0; i < N; i++) {
    distribution[r0 + i*l] = 0;
  }

  for (var i = 0; i < values.length; i++) {
    final num j = (values[i] - r0) ~/ l;
    if (distribution.containsKey(r0 + j*l)) {
      distribution[r0 + j*l] = distribution[r0 + j*l]! + 1;
    }
  }

  return distribution;
}