use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::time::{Instant};
use std::convert::TryInto;

const INPUT_PATH: &str = "11.input.sample";
const WIDTH: i32 = 10;
const HEIGHT: i32 = 10;
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
    let start = Instant::now();

    let coords = parse_input();
    let seats = seat_data(&coords);

    print(&seats);

    println!("{}ms", start.elapsed().as_millis());
}

fn print(seats: &Vec<Seat>) {
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
