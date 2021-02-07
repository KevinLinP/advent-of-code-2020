use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::time::{Instant, Duration};

//const INPUT_PATH: &str = "11.input.sample";
//const WIDTH: i32 = 10;
//const HEIGHT: i32 = 10;

const INPUT_PATH: &str = "11.input";
const WIDTH: usize = 92;
const HEIGHT: usize = 94;

const DIRECTIONS: [(i32, i32); 8] = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 1),
    (1, -1), (1, 0), (1, 1),
];

#[derive(Copy, Clone)]
struct Coord {
    x: usize,
    y: usize,
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

    let duration = start.elapsed();
    print_duration(duration);
    //print_seats(&seats);
}

fn print_duration(duration: Duration) {
    if duration.as_micros() < 1000 {
        println!("{} microseconds", duration.as_micros());
    } else {
        println!("{} milliseconds", duration.as_millis());
    }
}

fn solve(seats: &Vec<Seat>) {
    let mut current_grid = [[false; WIDTH]; HEIGHT];
    let mut next_grid = [[false; WIDTH]; HEIGHT];
    let mut any_changed = true;
    let mut iteration_count = 0;

    while any_changed {
        any_changed = false;
        iteration_count += 1;

        for seat in seats {
            let coord = seat.coord;
            let current_value = current_grid[coord.y][coord.x];
            let mut occupied_count = 0;

            for visible in &seat.visible_coords {
                if current_grid[visible.y][visible.x] {
                    occupied_count += 1;

                    if !current_value { break; }
                    if current_value && occupied_count >= 5 { break; }
                }
            }

            let mut next_value = current_value;
            if current_value && occupied_count >= 5 {
                next_value = false;
                any_changed = true;
            } else if !current_value && occupied_count == 0 {
                next_value = true;
                any_changed = true;
            }
            next_grid[coord.y][coord.x] = next_value;
        }

        let temp_grid = current_grid;
        current_grid = next_grid;
        next_grid = temp_grid;
    }

    let num_occupied_seats = current_grid.iter().fold(0, |grid_acc, &row|
        grid_acc + row.iter().fold(0, |row_acc, seat|
            row_acc + match *seat {true => 1, false => 0}
        )
    );

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
    let mut seat_data = Vec::with_capacity(coords.len());
    let mut grid = [[false; WIDTH]; HEIGHT];

    for coord in coords {
        grid[coord.y][coord.x] = true;
    }

    for coord in coords {
        let mut visible_coords = Vec::with_capacity(8);

        for direction in &DIRECTIONS {
            let mut x = coord.x as i32;
            let mut y = coord.y as i32;

            loop {
                x += direction.0;
                y += direction.1;

                if (x < 0) || (x >= WIDTH as i32) || (y < 0) || (y >= HEIGHT as i32) {
                    break;
                }

                if grid[y as usize][x as usize] {
                    visible_coords.push(Coord {x: x as usize, y: y as usize});
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
                coord.push(Coord {x: x, y: y});
            }
        }
    }

    coord
}
