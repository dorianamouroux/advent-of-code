extern crate my_lib;

#[derive(Debug, Copy, Clone)]
struct Number {
    original_pos: i128,
    value: i128,
}

fn circular_index(position: i128, size_list: i128) -> i128 {
    let value = if position < 0 {
        position + size_list * ((position.abs() / size_list) + 1)
    } else {
        position
    };
    value % size_list
}

fn rearrange_numbers(input: &mut Vec<Number>) {
    let size_input = input.len() as i128;
    for i in 0..size_input {
        let position = input.iter().position(|n| n.original_pos == i).unwrap();
        let number = input.remove(position);
        let new_index = circular_index(number.value + position as i128, size_input - 1);
        input.insert(new_index as usize, number);
    }
}

fn get_number_at_n_pos(input: &Vec<Number>, pos: usize) -> i128 {
    let zero = input.iter().position(|n| n.value == 0).unwrap();
    let real_pos = (zero + pos) % input.len();
    input[real_pos].value
}

fn part1(input: &Vec<Number>) -> i128 {
    let mut numbers = input.clone();
    rearrange_numbers(&mut numbers);
    get_number_at_n_pos(&numbers, 1000) + get_number_at_n_pos(&numbers, 2000) + get_number_at_n_pos(&numbers, 3000)
}

fn part2(input: &Vec<Number>) -> i128 {
    let mut numbers = input.clone().iter().map(|n| {
        Number{value: n.value * 811589153, original_pos: n.original_pos}
    }).collect::<Vec<Number>>();

    for _ in 0..10 { rearrange_numbers(&mut numbers); }
    get_number_at_n_pos(&numbers, 1000) + get_number_at_n_pos(&numbers, 2000) + get_number_at_n_pos(&numbers, 3000)
}

fn parse(filename: &str) -> Vec<Number> {
    my_lib::readfile(filename).split("\n").enumerate().map(|(pos, line)| {
        let value = line.parse::<i128>().unwrap();
        Number{value: value, original_pos: pos as i128}
    }).collect()
}

fn main() {
    let example = parse("day20/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let mut input = parse("day20/input.txt");
    println!("part1 input = {}", part1(&mut input));
    println!("part2 input = {}", part2(&input));
}
