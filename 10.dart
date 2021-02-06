import 'dart:convert';
import 'dart:io';

void main() async {
  var numbers = await parseInput();
  numbers.sort();
  print(numbers);

  onesTimesThrees(numbers);
  print('');

  numPaths(numbers + [numbers.last + 3]);
}

// given answer > trillions,
// this requires int to be 64-bits, which it should be
void numPaths(List<int> numbers) {
  final allNumPaths = new Map<int, int>();
  allNumPaths[0] = 1;

  for (var number in numbers) {
    int numPaths = 0;

    for (var offset in [-1, -2, -3]) {
      int prevNum = number + offset; // subtract the offset at your own peril
      var prevNumPaths = allNumPaths[prevNum];
      if (prevNumPaths != null) {
        numPaths += prevNumPaths;
      }
    }
    allNumPaths[number] = numPaths;
  }

  print(allNumPaths);
}

void onesTimesThrees(List<int> numbers) {
  final counts = new Map<int, int>();

  var previousNumber = 0;
  for (int i = 0; i < numbers.length; i++) {
    final number = numbers[i];
    final difference = number - previousNumber;

    var previousDifference = counts[difference];
    if (previousDifference == null) {
      counts[difference] = 1;
    } else {
      counts[difference] = previousDifference + 1;
    }

    previousNumber = number;
  }

  // that final difference
  counts[3] += 1;

  print(counts);
  print('${counts[1]} * ${counts[3]} = ${counts[1] * counts[3]}');
}

Future<List<int>> parseInput() async {
  List<int> numbers = [];

  Stream<List<int>> stream = new File('10.input').openRead();

  await stream
  .transform(utf8.decoder)
  .transform(LineSplitter())
  .forEach((line) {
    numbers.add(int.parse(line));
  });

  return numbers;
}