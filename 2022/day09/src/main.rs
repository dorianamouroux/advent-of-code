extern crate my_lib;

use std::collections::HashSet;

fn should_tail_move(pos_head: &(i32, i32), pos_tail: &(i32, i32)) -> bool {
    (pos_head.0 - pos_tail.0).abs() >= 2 || (pos_head.1 - pos_tail.1).abs() >= 2
}

fn move_head(direction: &str, pos_head: &(i32, i32)) -> (i32, i32) {
    match direction {
        "U" => (pos_head.0, pos_head.1 + 1),
        "D" => (pos_head.0, pos_head.1 - 1),
        "L" => (pos_head.0 - 1, pos_head.1),
        "R" => (pos_head.0 + 1, pos_head.1),
        _ => (pos_head.0, pos_head.1),
    }
}

fn move_tail(pos_head: &(i32, i32), pos_tail: &(i32, i32)) -> (i32, i32) {
    if pos_head.0 == pos_tail.0 { // same column
        let new_y = if pos_head.1 > pos_tail.1 { pos_tail.1 + 1 } else { pos_tail.1 - 1};
        (pos_tail.0, new_y)
    } else if pos_head.1 == pos_tail.1 { // same line
        let new_x = if pos_head.0 > pos_tail.0 { pos_tail.0 + 1 } else { pos_tail.0 - 1};
        (new_x, pos_tail.1)
    } else {
        let new_x = if pos_head.0 > pos_tail.0 { pos_tail.0 + 1 } else { pos_tail.0 - 1};
        let new_y = if pos_head.1 > pos_tail.1 { pos_tail.1 + 1 } else { pos_tail.1 - 1};
        (new_x, new_y)
    }
}


fn update_train(all_knots: &mut Vec<(i32, i32)>, direction: &str) {
    all_knots[0] = move_head(direction, &all_knots[0]);
    for i in 1..all_knots.len() {
        let pos_head = all_knots[i - 1];
        if should_tail_move(&pos_head, &all_knots[i]) {
            all_knots[i] = move_tail(&pos_head, &all_knots[i]);
        }
    }
}

fn resolve_with_n_knots(itenary: &Vec<(String, i32)>, nb_knots: i32) -> i32{
    let mut history_tail: HashSet<(i32, i32)> = HashSet::new();
    let mut all_knots: Vec<(i32, i32)> = (0..nb_knots).map(|_| (0, 0)).collect();

    for step in itenary {
        for _ in 0..step.1 {
            update_train(&mut all_knots, &step.0);
            history_tail.insert(*all_knots.last().unwrap());
        }
    }

    history_tail.len().try_into().unwrap()
}

fn part1(itenary: &Vec<(String, i32)>) -> i32 {
    resolve_with_n_knots(itenary, 2)
}

fn part2(itenary: &Vec<(String, i32)>) -> i32 {
    resolve_with_n_knots(itenary, 10)
}

fn parse(filename: &str) -> Vec<(String, i32)> {
    my_lib::readfile(filename).split("\n").map(|line| {
        let (direction, amount) = line.split_once(" ").unwrap();
        let nb = amount.parse::<i32>().unwrap();
        (direction.to_string(), nb)
    }).collect()
}

fn main() {
    let example = parse("day09/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let example_2 = parse("day09/example_2.txt");
    println!("part1 example 2 = {}", part1(&example_2));
    println!("part2 example 2 = {}", part2(&example_2));

    let input = parse("day09/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
