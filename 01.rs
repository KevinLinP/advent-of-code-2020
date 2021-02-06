// it's a safer C. really great compiler error messages.

use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashSet;

fn main() {
    let numbers_set = parse_input();
    //part_1(numbers_set);
    let mut numbers = Vec::new();

    for number in &numbers_set {
        numbers.push(number);
    }

    for (first_index, first_number_ref) in numbers.iter().enumerate() {
        let first_number = *first_number_ref;
        for second_index in first_index..(numbers_set.len() - 1) {
            let second_number = numbers[second_index];
            let third_number = 2020 - first_number - second_number;

            if numbers_set.contains(&third_number) {
                println!("{}", first_number * second_number * third_number);
                return
            }
        }
    }
}

#[allow(dead_code)]
fn part_1(numbers: HashSet<i32>) {
    for number in &numbers {
        if *number > 1010i32 {
            continue;
        }

        let other_number = 2020 - number;
        if numbers.contains(&other_number) {
            println!("{}", number * other_number);
            return
        }
    }
}

fn parse_input() -> HashSet<i32> {
    let mut numbers = HashSet::new();

    let file = File::open("1.input").unwrap();
    let reader = BufReader::new(file);

    for line in reader.lines() {
        let number: i32 = line.unwrap().trim().parse().unwrap();
        numbers.insert(number);
    }

    numbers
}
