use std::fs::File;
use std::io::{prelude::*, BufReader};
use regex::Regex;
use fnv::FnvHashMap;

const DEBUG: bool = true;
const INPUT_PATH: &str = "14.input.sample";

fn main() {
    let mask_regex = Regex::new(r"^mask = ([X01]{36})$").unwrap();
    let assignment_regex = Regex::new(r"mem\[(\d+)\] = (\d+)").unwrap();

    let file = File::open(INPUT_PATH).unwrap();
    let reader = BufReader::new(file);

    let mut mask: [i8; 36] = [0; 36];
    let mut memory: FnvHashMap<u16, u64> = FnvHashMap::with_capacity_and_hasher(1000, Default::default());
    let mut bit_values: [u64; 36] = [0; 36];

    for i in 0..36 {
        bit_values[i] = 2u64.pow((35 - i) as u32);
    }

    if DEBUG {
        for n in bit_values.iter() {
            print!("{} ", n);
        }
        println!("");
    }

    for wrapped_line in reader.lines() {
        let line = wrapped_line.unwrap();

        if line.starts_with("mask") {
            let captures = mask_regex.captures(&line).unwrap();
            let mask_string = captures.get(1).unwrap().as_str();

            for (i, char) in mask_string.chars().enumerate() {
                let val = match char {
                    'X' => 0,
                    '1' => 1,
                    '0' => -1,
                    _ => panic!("unexpected char")
                };

                mask[i] = val as i8;
            }

            if DEBUG {
                for n in mask.iter() {
                    print!("{} ", n);
                }
                println!("");
            }
        } else if line.starts_with("mem") {
            let captures = assignment_regex.captures(&line).unwrap();
            let index: u16 = captures.get(1).unwrap().as_str().parse().unwrap();
            let value: u64 = captures.get(2).unwrap().as_str().parse().unwrap();

            if DEBUG {
                println!("{} {}", index, value);
            }
        } else {
            panic!("unexpected line");
        }
    }
}
