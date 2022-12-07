#[macro_use] extern crate scan_fmt;

extern crate my_lib;

use std::collections::{LinkedList, HashMap};
use itertools::Itertools;

type Crates = HashMap<i32, LinkedList<char>>;
struct Instruction {
    nb: i32,
    from: i32,
    to: i32
}

fn part1(crates_input: &Crates, instructions: &Vec<Instruction>)-> String {
    let mut crates = crates_input.clone();

    for instruction in instructions {
        for _ in 0..instruction.nb {
            let origin = crates.entry(instruction.from).or_default();
            let elem = origin.pop_front().unwrap();
            let dest = crates.entry(instruction.to).or_default();
            dest.push_front(elem);
        }
    }

    crates.keys().sorted().map(|key| {
        crates[key].front().unwrap()
    }).collect()
}


fn part2(crates_input: &Crates, instructions: &Vec<Instruction>)-> String {
    let mut crates = crates_input.clone();

    for instruction in instructions {
        let mut cut_list = LinkedList::new();

        // update the origin list by cutting at instruction.nb and storing the cut part in cut_list
        crates.entry(instruction.from).and_modify(|list| {
            let new_origin = list.split_off(instruction.nb as usize);
            cut_list = list.clone();
            *list = new_origin;
        });

        // update the dest list by prepending cut_list
        crates.entry(instruction.to).and_modify(|list| {
            cut_list.append(list);
            *list = cut_list;
        });
    }

    crates.keys().sorted().map(|key| {
        crates[key].front().unwrap()
    }).collect()
}

fn parse(filename: &str) -> (Crates, Vec<Instruction>) {
    let file = my_lib::readfile(filename);
    let (stacks_str, instructions_str) = file.split_once("\n\n").expect("bad input");

    let mut crates: Crates = HashMap::with_capacity(10);

    for stack in stacks_str.split("\n") {
        for (i, c) in stack.chars().enumerate() {
            if !c.is_alphabetic() { continue; }
            let stack_id = (i / 4) as i32;
            let stack_in_crates = crates.entry(stack_id + 1).or_insert_with(|| LinkedList::new());
            stack_in_crates.push_back(c)
        }
    }

    let instructions: Vec<Instruction> = instructions_str.split("\n").map(|line| {
        let (nb, from, to) = scan_fmt!(&line, "move {} from {} to {}", i32, i32, i32).expect("wrong instruction");
        Instruction {nb, from, to}
    }).collect();

    return (crates, instructions)
}

fn main() {
    let (crates, instructions) = parse("day05/example.txt");
    println!("part1 example = {}", part1(&crates, &instructions));
    println!("part2 example = {}", part2(&crates, &instructions));

    let (crates, instructions) = parse("day05/input.txt");
    println!("part1 input = {}", part1(&crates, &instructions));
    println!("part2 input = {}", part2(&crates, &instructions));
}
