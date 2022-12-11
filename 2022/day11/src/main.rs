use std::cell::RefCell;
use itertools::Itertools;

#[macro_use] extern crate scan_fmt;

extern crate my_lib;

#[derive(Debug, Clone)]
struct Monkey {
    items: RefCell<Vec<usize>>,
    left_operand: Option<usize>,
    right_operand: Option<usize>,
    operator: String,
    test_divisible: usize,
    if_true: usize,
    if_false: usize,
    nb_item_inspected: usize,
}

fn do_math(monkey: &Monkey, value: usize) -> usize {
    let left = match monkey.left_operand {
        Some(x) => x,
        None => value
    };
    let right = match monkey.right_operand {
        Some(x) => x,
        None => value
    };
    match monkey.operator.as_str() {
        "+" => left + right,
        "*" => left * right,
        _ => panic!("unhandled operator")
    }
}

fn execute_one_cycle(monkeys: &mut Vec<Monkey>, divide_by: usize, magic_number: usize) {
    for i in 0..monkeys.len() {
        let nb_item: usize = monkeys[i].items.borrow().len();
        for j in 0..nb_item {
            let monkey = &monkeys[i];
            let value = do_math(monkey, monkey.items.borrow()[j]) / divide_by % magic_number;
            let to_which_monkey = if value % monkeys[i].test_divisible == 0 { monkey.if_true } else { monkey.if_false };
            monkeys[to_which_monkey].items.borrow_mut().push(value);
            monkeys[i].nb_item_inspected += 1;
        }
        monkeys[i].items = RefCell::new(vec![]);
    }
}

fn compute_magic_number(monkeys: &Vec<Monkey>) -> usize {
    monkeys.iter().map(|monkey| monkey.test_divisible).sorted().product()
}

fn part1(input: &Vec<Monkey>) -> usize {
    let magic_number = compute_magic_number(input);
    let mut monkeys = input.clone();
    for _ in 0..20 {
        execute_one_cycle(&mut monkeys, 3, magic_number);
    }

    monkeys.iter().map(|monkey| monkey.nb_item_inspected).sorted().rev().take(2).product()
}

fn part2(input: &Vec<Monkey>) -> usize {
    let magic_number = compute_magic_number(input);
    let mut monkeys = input.clone();
    for _ in 0..10000 {
        execute_one_cycle(&mut monkeys, 1, magic_number);
    }

    monkeys.iter().map(|monkey| monkey.nb_item_inspected).sorted().rev().take(2).product()
}


fn parse(filename: &str) -> Vec<Monkey> {
    let file = my_lib::readfile(filename);
    let groups = my_lib::to_group(&file);

    groups.iter().map(|line| {
        let by_line = line.split("\n").map(|line| line.trim()).collect::<Vec<&str>>();

        let starting_items = scan_fmt!(&by_line[1], "Starting items: {[^.]}}", String).unwrap();
        let (raw_left_operand, operator, raw_right_operand) = scan_fmt!(&by_line[2], "Operation: new = {} {} {}", String, String, String).unwrap();
        let test_divisible = scan_fmt!(&by_line[3], "Test: divisible by {}", usize).unwrap();
        let if_true = scan_fmt!(&by_line[4], "If true: throw to monkey {}", usize).unwrap();
        let if_false = scan_fmt!(&by_line[5], "If false: throw to monkey {}", usize).unwrap();

        let items = starting_items.split(", ").map(|item| {
            item.parse::<usize>().unwrap()
        }).collect();

        let left_operand = if raw_left_operand == "old" { None } else { Some(raw_left_operand.parse::<usize>().unwrap()) };
        let right_operand = if raw_right_operand == "old" { None } else { Some(raw_right_operand.parse::<usize>().unwrap()) };

        Monkey {
            items: RefCell::new(items),
            left_operand,
            right_operand,
            operator: operator,
            test_divisible,
            if_true,
            if_false,
            nb_item_inspected: 0,
        }
    }).collect()
}

fn main() {
    let example = parse("day11/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day11/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
