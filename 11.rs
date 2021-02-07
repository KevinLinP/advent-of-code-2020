use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::time::{Instant};
use std::convert::TryInto;
//use std::mem;

//const INPUT_PATH: &str = "11.input.sample";
//const WIDTH: i32 = 10;
//const HEIGHT: i32 = 10;

const INPUT_PATH: &str = "11.input";
const WIDTH: i32 = 92;
const HEIGHT: i32 = 94;

const DIRECTIONS: [(i32, i32); 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    //
    (0, -1),
    (0, 1),
    //
    (1, -1),
    (1, 0),
    (1, 1),
];

#[derive(Copy, Clone)]
struct Coord {
    x: i32,
    y: i32,
}

struct Seat {
    coord: Coord,
    visible_coords: Vec<Coord>,
}

fn main() {
    let coords = parse_input();
    let start = Instant::now();

    let seats = seat_data(&coords);
    solve(&seats);

    let elapsed = start.elapsed();
    //print_seats(&seats);
    println!("{} microseconds", elapsed.as_micros());
}

fn solve(seats: &Vec<Seat>) {
    let mut current_grid = [[false; WIDTH as usize]; HEIGHT as usize];
    let mut next_grid = [[false; WIDTH as usize]; HEIGHT as usize];
    let mut any_changed = true;
    let mut iteration_count = 0;

    while any_changed {
        any_changed = false;
        iteration_count += 1;

        // could cull seats that have less than 5 visible coords
        // could add early exits based on current_value
        for seat in seats {
            let coord = seat.coord;
            let current_value = current_grid[coord.y as usize][coord.x as usize];
            let mut occupied_count = 0;

            for visible in &seat.visible_coords {
                if current_grid[visible.y as usize][visible.x as usize] {
                    occupied_count += 1
                }
            }

            if current_value && occupied_count >= 5 {
                next_grid[coord.y as usize][coord.x as usize] = false;
                any_changed = true
            } else if !current_value && occupied_count == 0 {
                next_grid[coord.y as usize][coord.x as usize] = true;
                any_changed = true
            } else {
                next_grid[coord.y as usize][coord.x as usize] = current_value;
            }
        }

        let temp_grid = current_grid;
        current_grid = next_grid;
        next_grid = temp_grid;
    }

    let mut num_occupied_seats = 0;
    for row in &current_grid {
        for occupied in row {
            if *occupied {
                num_occupied_seats += 1
            }
        }
    }

    println!("iteration_count:{} occupied_seats:{}", iteration_count, num_occupied_seats);
}

#[allow(dead_code)]
fn print_seats(seats: &Vec<Seat>) {
    for seat in seats {
        print!("({}, {}): ", seat.coord.x, seat.coord.y);
        for visible in &seat.visible_coords {
            print!("({}, {}) ", visible.x, visible.y);
        }
        println!("");
    }
}

fn seat_data(coords: &Vec<Coord>) -> Vec<Seat> {
    let mut seat_data = vec![];
    let mut grid = [[false; WIDTH as usize]; HEIGHT as usize];

    for coord in coords {
        grid[coord.y as usize][coord.x as usize] = true;
    }

    for coord in coords {
        let mut visible_coords = vec![];

        for direction in &DIRECTIONS {
            let mut x = coord.x;
            let mut y = coord.y;

            loop {
                x += direction.0;
                y += direction.1;

                if (x < 0) || (x >= WIDTH) || (y < 0) || (y >= HEIGHT) {
                    break;
                }

                if grid[y as usize][x as usize] {
                    visible_coords.push(Coord {x: x, y: y});
                    break;
                }
            }
        }

        seat_data.push(Seat {
            coord: *coord,
            visible_coords: visible_coords
        })
    }

   seat_data
}

fn parse_input() -> Vec<Coord> {
    let mut coord = vec![];

    let file = File::open(INPUT_PATH).unwrap();
    let reader = BufReader::new(file);

    for (y, line) in reader.lines().enumerate() {
        for (x, char) in line.unwrap().chars().enumerate() {
            if char == 'L' {
                coord.push(Coord {x: x.try_into().unwrap(), y: y.try_into().unwrap()});
            }
        }
    }

    coord
}
