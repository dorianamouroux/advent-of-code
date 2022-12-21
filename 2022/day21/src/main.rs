extern crate my_lib;

use std::collections::HashMap;


#[derive(Debug)]
enum Monkey {
    Number(i128),
    Operation(String, fn(i128, i128) -> Option<i128>, String),
}

fn get_value(monkeys: &HashMap<String, Monkey>, monkey_name: &String) -> Option<i128> {
    match monkeys.get(monkey_name).unwrap() {
        Monkey::Number(v) => Some(*v),
        Monkey::Operation(left, func, right) => {
            match (get_value(monkeys, left), get_value(monkeys, right)) {
                (Some(left), Some(right)) => func(left, right),
                _ => None
            }
        },
    }
}

fn part1(monkeys: &HashMap<String, Monkey>) -> i128 {
    get_value(&monkeys, &String::from("root")).unwrap()
}

fn compute(monkeys: &mut HashMap<String, Monkey>, for_monkey: &String, value: i128) -> Option<i128> {
    monkeys.insert(String::from("humn"), Monkey::Number(value));
    get_value(monkeys, for_monkey)
}

// multiple value can yield the same result, so we look for the smaller one
fn find_smaller_value(monkeys: &mut HashMap<String, Monkey>, for_monkey: &String, value: i128) -> i128 {
    let original_value = compute(monkeys, for_monkey, value);

    let mut starting_number = value - 1;

    while compute(monkeys, for_monkey, starting_number) == original_value {
        starting_number -= 1;
    }

    starting_number + 1
}
 
fn part2(monkeys: &mut HashMap<String, Monkey>) -> i128 {
    let (left, number_to_equal) = match monkeys.get("root").unwrap() {
        Monkey::Operation(left, _, right) => (String::from(left), get_value(monkeys, right)),
        _ => panic!("Wrong input")
    };

    let mut start = 0;
    let mut end = i128::MAX;

    // while we go number from start -> end, the number may increase or decrease which change how we 
    // change the limit of the binary search
    let are_number_growing = match (compute(monkeys, &left, 0), compute(monkeys, &left, 10000)) {
        (Some(a), Some(b)) => a < b,
        _ => false,
    };

    // binary search :)
    while start <= end {
        let middle = start + (end - start) / 2;
        let computed_value = compute(monkeys, &left, middle);

        // int overflow, we consider the starting number too large 
        if computed_value == None {
            end = middle + 1;
            continue
        }

        if computed_value == number_to_equal {
            return find_smaller_value(monkeys, &left, middle);
        }

        if are_number_growing {
            if computed_value > number_to_equal {
                end = middle + 1;
            } else {
                start = middle - 1;
            }
        } else {
            if computed_value > number_to_equal {
                start = middle - 1;
            } else {
                end = middle + 1;
            }
        }
    }
    -1
}

fn parse(filename: &str) -> HashMap<String, Monkey> {
    let mut monkeys = HashMap::new();

    for line in my_lib::readfile(filename).split("\n") {
        let (monkey_name, operation) = line.split_once(": ").unwrap();

        let monkey = match operation.parse::<i128>() {
            Ok(number) => Monkey::Number(number),
            Err(_) => {
                let (left, rest) = operation.split_once(" ").unwrap();
                let (sign, right) = rest.split_once(" ").unwrap();

                let sign = match sign {
                    "+" => i128::checked_add,
                    "-" => i128::checked_sub,
                    "*" => i128::checked_mul,
                    "/" => i128::checked_div,
                    _ => panic!("Wrong input")
                };

                Monkey::Operation(String::from(left), sign, String::from(right))

            }
        };

        monkeys.insert(String::from(monkey_name), monkey);
    }

    monkeys
}

fn main() {
    let mut example = parse("day21/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&mut example));

    let mut input = parse("day21/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&mut input));
}
