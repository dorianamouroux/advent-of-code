extern crate my_lib;

use std::collections::HashMap;

#[derive(Debug, PartialEq, Eq, Hash, Clone, Copy)]
enum Shape {
    Rock,
    Paper,
    Cisor,
}

fn get_losing_shape(shape: &Shape) -> Shape {
    HashMap::from([
        (Shape::Rock, Shape::Cisor),
        (Shape::Paper, Shape::Rock),
        (Shape::Cisor, Shape::Paper),
        ]).get(shape).copied().unwrap()
}

fn get_winning_shape(shape: &Shape) -> Shape {
    HashMap::from([
        (Shape::Cisor, Shape::Rock),
        (Shape::Rock, Shape::Paper),
        (Shape::Paper, Shape::Cisor),
        ]).get(shape).copied().unwrap()
}

fn get_nb_point_for_round(left: &Shape, right: &Shape) -> i32 {
    if left == right {
        return 3;
    }
    if get_losing_shape(right) == *left {
        return 6;
    }
    return 0;
}

fn get_point_of_shape(shape: &Shape) -> i32 {
    let point_per_move = HashMap::from([
        (Shape::Rock, 1),
        (Shape::Paper, 2),
        (Shape::Cisor, 3),
        ]);
    *point_per_move.get(shape).unwrap()
}

fn part1(input: &Vec<(Shape, char)>) -> i32 {
    let mut score = 0;

    for (left, right) in input {
        let move_right = match right {
            'X' => Shape::Rock,
            'Y' => Shape::Paper,
            'Z' => Shape::Cisor,
            _ => panic!("not good input")
        };

        score += get_nb_point_for_round(left, &move_right);
        score += get_point_of_shape(&move_right);
    }

    score
}

fn part2(input: &Vec<(Shape, char)>) -> i32 {
    let mut score = 0;

    for (left, right) in input {
        score += match right {
            'X' => 0 + get_point_of_shape(&get_losing_shape(left)),
            'Y' => 3 + get_point_of_shape(left),
            'Z' => 6 + get_point_of_shape(&get_winning_shape(left)),
            _ => panic!("not good input"),
        };
    }

    score
}

fn parse(filename: &str) -> Vec<(Shape, char)> {
    my_lib::readfile(filename).split("\n").map(|line| {
        let (left, right) = line.split_once(" ").expect("wrong input");
        let move_left = match left.chars().next().unwrap() {
            'A' => Shape::Rock,
            'B' => Shape::Paper,
            'C' => Shape::Cisor,
            _ => panic!("not good input")
        };
        (move_left, right.chars().next().unwrap())
    }).collect()
}

fn main() {
    let example = parse("day02/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day02/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
