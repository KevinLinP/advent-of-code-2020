const TARGET: usize = 2020;
const START: [u16; 6] = [10,16,6,0,1,17];

fn main() {
    let mut all_last_mentioned = [0u16; TARGET];

    for (turn_num, num) in START.iter().enumerate() {
        all_last_mentioned[*num as usize] = turn_num as u16 + 1;
        //println!("{}", num);
    }

    //for (i, num) in all_last_mentioned.iter().enumerate() {
        //print!("{}:{}, ", i, num);
    //}
    //println!("");

    let mut current_num = 0u16;
    let mut last_number_mentioned_ago = 0u16;

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
            last_number_mentioned_ago = iteration as u16 - current_num_last_mentioned;
        }

        all_last_mentioned[current_num as usize] = iteration as u16;
    }

    println!("{}", current_num);
}
