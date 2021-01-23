use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashSet;

fn main() {
    let numbers = parse_input();

    for number in &numbers {
        if number > &1010i32 {
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
