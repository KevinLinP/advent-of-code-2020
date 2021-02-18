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
            let mut input_value: u64 = captures.get(2).unwrap().as_str().parse().unwrap();
            let mut write_value: u64 = 0;

            if DEBUG {
                println!("{} {}", index, input_value);
            }

            for (i, bit_value) in bit_values.iter().enumerate() {
                let mask_value = mask[i];
                let mut input_value_bit = false;

                if input_value >= *bit_value {
                    input_value -= *bit_value;
                    input_value_bit = true;
                }

                match mask_value {
                    -1 => (),
                    1 => {
                        write_value += bit_value;
                    },
                    0 => {
                        if input_value_bit {
                            write_value += bit_value;
                        }
                    },
                    _ => {
                        panic!("unexpected mask_value");
                    }
                }
            }

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
