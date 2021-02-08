use std::time::{Instant};
use std::collections::{hash_map::Entry};
use fnv::FnvHashMap;

//const TARGET: usize = 2020;
const TARGET: usize = 30_000_000;
type UInt = u32;

//const START: [UInt; 3] = [0,3,6];
const START: [UInt; 6] = [10,16,6,0,1,17];

const BOUNDARY: UInt = 2_000_000; // limited by (default) stack size
const HASH_CAPACITY: usize = 3_000_000;

fn main() {
    let start = Instant::now();
    solve();
    let duration = start.elapsed();

    println!("{}.{:03}s", duration.as_secs(), duration.subsec_millis());
}

fn solve() {
    // split optimization stolen from
    // https://github.com/timvisee/advent-of-code-2020/blob/master/day15b/src/main.rs#L22
    //
    // I tried at large Vec for _high, but I think the Rust's memory initialization time kills it
    let mut last_seen_low = [0 as UInt; BOUNDARY as usize + 1];
    let mut last_seen_high: FnvHashMap<UInt, UInt> = FnvHashMap::with_capacity_and_hasher(HASH_CAPACITY, Default::default());

    for (i, num) in START.iter().enumerate() {
        let turn_num = i as UInt + 1;
        last_seen_low[*num as usize] = turn_num;
    }

    //for (i, num) in all_last_mentioned.iter().enumerate() {
        //print!("{}:{}, ", i, num);
    //}
    //println!("");

    let mut current_num = 0 as UInt;
    let mut last_number_mentioned_ago = 0 as UInt;

    for iteration_usize in (START.len() + 1)..(TARGET+1) {
        let iteration = iteration_usize as UInt;
        if last_number_mentioned_ago == 0 {
            current_num = 0;
        } else {
            current_num = last_number_mentioned_ago;
        }

        if current_num <= (BOUNDARY as UInt) {
            let current_num_last_mentioned = last_seen_low[current_num as usize];
            if current_num_last_mentioned == 0 {
                last_number_mentioned_ago = 0;
            } else {
                last_number_mentioned_ago = iteration - current_num_last_mentioned;
            }

            last_seen_low[current_num as usize] = iteration;
        } else {
            // accessing by .entry() cribbed from
            // https://github.com/timvisee/advent-of-code-2020/blob/master/day15b/src/main.rs#L28
            match last_seen_high.entry(current_num) {
                Entry::Occupied(mut entry) => {
                    let previous_value = entry.insert(iteration);
                    last_number_mentioned_ago = iteration - previous_value;
                }
                Entry::Vacant(entry) => {
                    last_number_mentioned_ago = 0;
                    entry.insert(iteration);
                }
            }
        }

        if iteration % 5_000_000 == 0 {
            println!("iteration:{} high_capacity:{}", iteration, last_seen_high.capacity());
        }
    }

    println!("{}", current_num);
}
