extern crate my_lib;

use std::ops::{RangeInclusive};

fn part1(input: &Vec<(RangeInclusive<i32>, RangeInclusive<i32>)>) -> i32 {
    input.iter().filter(|segments| {
        let (a, b) = segments;
        range_fully_contained(&a, &b) || range_fully_contained(&b, &a)
    }).count().try_into().unwrap()
}

fn part2(input: &Vec<(RangeInclusive<i32>, RangeInclusive<i32>)>) -> i32 {
    input.iter().filter(|segments| {
        let (a, b) = segments;
        range_partially_contained(&a, &b) || range_partially_contained(&b, &a)
    }).count().try_into().unwrap()
}


fn range_fully_contained(a: &RangeInclusive<i32>, b: &RangeInclusive<i32>) -> bool {
    a.contains(b.start()) && a.contains(b.end())
}

fn range_partially_contained(a: &RangeInclusive<i32>, b: &RangeInclusive<i32>) -> bool {
    a.contains(b.start()) || a.contains(b.end())
}

fn parse(filename: &str) -> Vec<(RangeInclusive<i32>, RangeInclusive<i32>)> {
    my_lib::readfile(filename)
        .split("\n")
        .map(|line| parse_line(line))
        .collect()
}

fn parse_line(line: &str) -> (RangeInclusive<i32>, RangeInclusive<i32>) {
    let segments: Vec<&str> = line.split(",").collect();

    return (parse_range(segments[0]), parse_range(segments[1]));
}

fn parse_range(range: &str) -> RangeInclusive<i32> {
    let start_end: Vec<&str> = range.split("-").collect();

    RangeInclusive::new(start_end[0].parse().unwrap(), start_end[1].parse().unwrap())
}

fn main() {
    let example = parse("example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
