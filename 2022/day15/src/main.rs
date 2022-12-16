use std::cmp;

#[macro_use] extern crate scan_fmt;
extern crate my_lib;

type Point = (i32, i32);

#[derive(PartialEq)]
enum OnPosition {
    Void,
    Beacon,
    InRangeBeacon,
    Sensor,
}

fn distance(a: &Point, b: &Point) -> i32 {
    (a.0 - b.0).abs() + (a.1 - b.1).abs()
}

fn whats_on_the_pos(points: &Vec<(Point, Point, i32)>, pos: &Point) -> (OnPosition, i32) {
    for (sensor, beacon, distance_beacon) in points {
        if beacon == pos { return (OnPosition::Beacon, 1) }
        if beacon == sensor { return (OnPosition::Sensor, 1)}
        let distance_pos = distance(&sensor, pos);
        if *distance_beacon >= distance_pos {
            let shift = *distance_beacon - distance_pos;
            let extra_offset = if pos.0 < sensor.0 { sensor.0 - pos.0} else { 0 };
            return (OnPosition::InRangeBeacon, shift + extra_offset + 1);
        }
    }
    return (OnPosition::Void, 1)
}

fn min_x(points: &Vec<(Point, Point, i32)>) -> i32 { 
    points.iter().map(|(sensor, beacon, distance)| {
        cmp::min(beacon.0 - distance, sensor.0 - distance)
    }).min().unwrap()
}

fn max_x(points: &Vec<(Point, Point, i32)>) -> i32 { 
    points.iter().map(|(sensor, beacon, distance)| {
        cmp::max(beacon.0 + distance, sensor.0 + distance)
    }).max().unwrap()
}

fn part1(points: &Vec<(Point, Point, i32)>, y: i32) -> i32 {
    let mut count_impossible = 0;
    let mut x = min_x(points);
    let max = max_x(points);
    while x < max {
        let (cell, offset) = whats_on_the_pos(points, &(x, y));
        if cell == OnPosition::InRangeBeacon {
            count_impossible += offset;
        }
        x += offset
    }
    count_impossible - 1
}

fn part2(points: &Vec<(Point, Point, i32)>, max: u128) -> u128 {
    for x in 0..max {
        let mut y = 0;
        while y < max{
            let (cell, offset) = whats_on_the_pos(points, &(x as i32, y as i32));
            y += offset as u128;
            if cell == OnPosition::Void {
                return x * 4000000 + y - 1
            }
        }
    }
    return 0
}

fn parse(filename: &str) -> Vec<(Point, Point, i32)> {
    my_lib::readfile(filename).split("\n").map(|line| {
        let (x, y, beacon_x, beacon_y) = scan_fmt!(&line, "Sensor at x={}, y={}: closest beacon is at x={}, y={}}", i32, i32, i32, i32).unwrap();
        let sensor = (x, y);
        let beacon = (beacon_x, beacon_y);
        (sensor, beacon, distance(&sensor, &beacon))
    }).collect::<Vec<(Point, Point, i32)>>()
}

fn main() {
    let example = parse("day15/example.txt");
    println!("part1 example = {}", part1(&example, 10));
    println!("part2 example = {}", part2(&example, 20));

    let input = parse("day15/input.txt");
    println!("part1 input = {}", part1(&input, 2000000));
    println!("part2 input = {}", part2(&input, 4000000));
}
