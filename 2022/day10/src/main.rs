extern crate my_lib;

fn inc_cycle(cycle: &mut i32, reg: i32) -> i32 {
    *cycle += 1;
    if vec![20, 60, 100, 140, 180, 220].contains(cycle) {
        return *cycle * reg;
    }
    return 0;
}

fn part1(instructions: &Vec<String>) -> i32 {
    let mut reg = 1;
    let mut cycle = 0;
    let mut strength = 0;

    for instruction in instructions {
        if instruction.starts_with("addx ") {
            let (_, value) = instruction.split_once(" ").unwrap();
            strength += inc_cycle(&mut cycle, reg);
            strength += inc_cycle(&mut cycle, reg);
            reg += value.parse::<i32>().unwrap();
        }
        if instruction == "noop" {
            strength += inc_cycle(&mut cycle, reg);
        }
    }

    strength
}

fn inc_cycle_and_draw(cycle: &mut i32, reg: i32) {
    let pos_cursor = *cycle % 40;
    let symbol = if vec![reg - 1, reg, reg + 1].contains(&pos_cursor) {"# "} else {"  "};
    print!("{}", symbol);
    if (*cycle + 1) % 40 == 0 {
        print!("\n");
    }
    *cycle += 1;
}

fn part2(instructions: &Vec<String>) {
    let mut reg = 1;
    let mut cycle = 0;

    for instruction in instructions {
        if instruction.starts_with("addx ") {
            let (_, value) = instruction.split_once(" ").unwrap();
            inc_cycle_and_draw(&mut cycle, reg);
            inc_cycle_and_draw(&mut cycle, reg);
            reg += value.parse::<i32>().unwrap();
        }
        if instruction == "noop" {
            inc_cycle_and_draw(&mut cycle, reg);
        }
    }
}

fn parse(filename: &str) -> Vec<String> {
    my_lib::readfile(filename).split("\n").map(str::to_string).collect()
}

fn main() {
    let example = parse("day10/example.txt");
    println!("part1 example = {}", part1(&example));

    part2(&example);

    let input = parse("day10/input.txt");
    println!("part1 input = {}", part1(&input));
    part2(&input);
}
