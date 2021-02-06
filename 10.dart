import 'dart:convert';
import 'dart:io';

void main() async {
  final counts = new Map<num, num>();

  var numbers = await parseInput();
  numbers.sort();
  print(numbers);

  var previousNumber = 0;
  for (int i = 0; i < numbers.length; i++) {
    final number = numbers[i];
    final difference = number - previousNumber;

    if (counts.containsKey(difference)) {
      counts[difference] += 1;
    } else {
      counts[difference] = 1;
    }

    previousNumber = number;
  }

  // that final difference
  counts[3] += 1;

  print(counts);
  print('${counts[1]} * ${counts[3]} = ${counts[1] * counts[3]}');
}

Future<List<num>> parseInput() async {
  List<num> numbers = [];

  Stream<List<int>> stream = new File('10.input').openRead();

  await stream
  .transform(utf8.decoder)
  .transform(LineSplitter())
  .forEach((line) {
    numbers.add(int.parse(line));
  });

  return numbers;
}