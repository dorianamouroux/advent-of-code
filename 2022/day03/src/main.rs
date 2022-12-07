extern crate my_lib;

use std::collections::HashSet;

fn get_priority(c: char) -> i32 {
    if c.is_uppercase() {
        return (c as i32) - 38;
    } else {
        return (c as i32) - 96;
    }
}

fn part1(input: &Vec<String>) -> i32 {
    input.iter().map(|line| {
        let (left, right) = line.split_at(line.len() / 2);
        let hashset_left: HashSet<char> = HashSet::from_iter(left.chars());
        let hashset_right: HashSet<char> = HashSet::from_iter(right.chars());
        let common_letter: &char = hashset_left
        .intersection(&hashset_right)
        .into_iter()
        .next()
        .expect("No character found in both side");

        get_priority(*common_letter)
    }).sum::<i32>()
}

fn part2(input: &Vec<String>) -> i32 {
    input.chunks(3).map(|group_of_three| {
        let hashset_1: HashSet<char> = HashSet::from_iter(group_of_three[0].chars());
        let hashset_2: HashSet<char> = HashSet::from_iter(group_of_three[1].chars());
        let hashset_3: HashSet<char> = HashSet::from_iter(group_of_three[2].chars());
        let common_1_and_2: HashSet<char> = hashset_1.intersection(&hashset_2).cloned().collect();

        let common_letter: &char = common_1_and_2
        .intersection(&hashset_3)
        .into_iter()
        .next()
        .expect("No character found in both side");

        get_priority(*common_letter)
    }).sum::<i32>()
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
