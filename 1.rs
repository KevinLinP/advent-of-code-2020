use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use std::collections::HashSet;

fn main() -> io::Result<()> {
    let numbers = parse_input();

    for number in &numbers {
        println!("{}", number);
    }

    Ok(())
}

fn parse_input() -> HashSet<i32> {
    let mut numbers = HashSet::new();

    let file = File::open("1.input.sample").unwrap();
    let reader = BufReader::new(file);

    for line in reader.lines() {
        let number: i32 = line.unwrap().trim().parse().unwrap();
        numbers.insert(number);
    }

    numbers
}
