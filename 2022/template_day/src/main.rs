extern crate my_lib;

fn part1(input: &Vec<String>) -> i32 {
    5
}

fn part2(input: &Vec<String>) -> i32 {
    6
}

fn parse(filename: &str) -> Vec<String> {
    my_lib::readfile(filename).split("\n").map(str::to_string).collect()
}

fn main() {
    let example = parse("day03/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day03/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
