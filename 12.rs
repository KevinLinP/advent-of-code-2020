use fnv::FnvHashMap;

const TARGET: usize = 30000000;
const START: [u32; 3] = [0,3,6];

fn main() {
    let mut all_last_mentioned = [0u32; TARGET / 16];

    for (turn_num, num) in START.iter().enumerate() {
        all_last_mentioned[*num as usize] = turn_num as u32 + 1;
        //println!("{}", num);
    }

    for (i, num) in all_last_mentioned.iter().enumerate() {
        print!("{}:{}, ", i, num);
    }
    println!("");

    let mut current_num = 0u32;
    let mut last_number_mentioned_ago = 0u32;

    for iteration in (START.len() + 1)..(TARGET+1) {
        if last_number_mentioned_ago == 0 {
            current_num = 0;
        } else {
            current_num = last_number_mentioned_ago;
        }
        //println!("iteration:{} current_num:{}", iteration, current_num);

        let current_num_last_mentioned = all_last_mentioned[current_num as usize];
        if current_num_last_mentioned == 0 {
            last_number_mentioned_ago = 0;
        } else {
            last_number_mentioned_ago = iteration as u32 - current_num_last_mentioned;
        }

        all_last_mentioned[current_num as usize] = iteration as u32;
    }

    println!("{}", current_num);
}
