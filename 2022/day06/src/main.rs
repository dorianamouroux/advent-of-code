extern crate my_lib;

use std::collections::HashSet;

// put the word in a hashset and count if the size of hashset is same as word
fn all_different(word: &str) -> bool {
    let bytes_iter = word.as_bytes().into_iter();
    HashSet::<&u8>::from_iter(bytes_iter).len() == word.len()
}

fn find_first_sequence_different(message: &str, length: usize) -> i32 {
    for (i, _c) in message.chars().enumerate() {
        let outbound = i + length;
        if all_different(&message[i..outbound]) {
            return outbound as i32;
        }
    }

    return -1
}

fn part1(input: &String) -> i32 {
    find_first_sequence_different(input, 4)
}

fn part2(input: &String) -> i32 {
    find_first_sequence_different(input, 14)
}

fn parse(filename: &str) -> String {
    my_lib::readfile(filename)
}

fn main() {
    let example = parse("day06/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day06/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
