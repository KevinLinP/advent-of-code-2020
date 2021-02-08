use fnv::FnvHashMap;

//const TARGET: usize = 2020;
const TARGET: usize = 30000000;

//const START: [u32; 3] = [0,3,6];
const START: [u32; 6] = [10,16,6,0,1,17];

fn main() {
    let mut all_last_mentioned: FnvHashMap<u32, u32> = FnvHashMap::with_capacity_and_hasher(TARGET / 5, Default::default());

    for (i, num) in START.iter().enumerate() {
        let turn_num = i as u32 + 1;
        all_last_mentioned.insert(*num, turn_num);
    }

    //for (i, num) in all_last_mentioned.iter().enumerate() {
        //print!("{}:{}, ", i, num);
    //}
    //println!("");

    let mut current_num = 0u32;
    let mut last_number_mentioned_ago = 0u32;

    for iteration in (START.len() + 1)..(TARGET+1) {
        if last_number_mentioned_ago == 0 {
            current_num = 0;
        } else {
            current_num = last_number_mentioned_ago;
        }
        //println!("iteration:{} current_num:{}", iteration, current_num);

        let current_num_last_mentioned = all_last_mentioned.get_mut(&current_num);
        match current_num_last_mentioned {
            Some(num) => {
                last_number_mentioned_ago = iteration as u32 - *num;
                *num = iteration as u32;
            }
            None => {
                last_number_mentioned_ago = 0;
                all_last_mentioned.insert(current_num, iteration as u32);
            }
        }

        if iteration % 5_000_000 == 0 {
            println!("iteration:{} hashmap_capacity:{}", iteration, all_last_mentioned.capacity());
        }
    }

    println!("{}", current_num);
}
