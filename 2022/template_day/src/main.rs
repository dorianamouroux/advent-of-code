extern crate my_lib;

fn part1(input: &Vec<&str>) -> i32 {
    5
}

fn part2(input: &Vec<&str>) -> i32 {
    6
}

fn parse(filename: &str) -> Vec<&str> {
    my_lib::readfile(filename)
        .split("\n")
        .collect()
}

fn main() {
    let example = parse("example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
