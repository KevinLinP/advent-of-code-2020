use std::fs::File;
use std::io::{prelude::*, BufReader};
use regex::Regex;
use fnv::FnvHashMap;

#[cfg(debug_assertions)]
const DEBUG: bool = true;
#[cfg(not(debug_assertions))]
const DEBUG: bool = false;

const INPUT_PATH: &str = "14.input";

fn main() {
    let mask_regex = Regex::new(r"^mask = ([X01]{36})$").unwrap();
    let assignment_regex = Regex::new(r"mem\[(\d+)\] = (\d+)").unwrap();

    let file = File::open(INPUT_PATH).unwrap();
    let reader = BufReader::new(file);

    let mut memory: FnvHashMap<u16, u64> = FnvHashMap::with_capacity_and_hasher(1000, Default::default());
    let mut and_mask: u64 = 0;
    let mut or_mask: u64 = 0;

    for wrapped_line in reader.lines() {
        let line = wrapped_line.unwrap();

        if line.starts_with("mask") {
            let captures = mask_regex.captures(&line).unwrap();
            let mask_string = captures.get(1).unwrap().as_str();

            // apply OR first
            let or_mask_string = mask_string.replace("X", "0");
            or_mask = u64::from_str_radix(&or_mask_string, 2).unwrap();

            let and_mask_string = mask_string.replace("X", "1");
            and_mask = u64::from_str_radix(&and_mask_string, 2).unwrap();

            if DEBUG {
                println!("{} {}", or_mask_string, and_mask_string);
            }
        } else if line.starts_with("mem") {
            let captures = assignment_regex.captures(&line).unwrap();
            let index: u16 = captures.get(1).unwrap().as_str().parse().unwrap();
            let input_value: u64 = captures.get(2).unwrap().as_str().parse().unwrap();

            if DEBUG {
                println!("{} {}", index, input_value);
            }

            let write_value = input_value | or_mask & and_mask;

            memory.insert(index, write_value);

            if DEBUG {
                println!("{}", write_value);
            }
        } else {
            panic!("unexpected line");
        }
    }

    let sum: u64 = memory.values().sum();

    println!("{}", sum);
}
