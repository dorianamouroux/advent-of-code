extern crate my_lib;

fn part1(calory_per_elf: &Vec<i32>) -> i32 {
    let max_calory = calory_per_elf.iter().max().unwrap();

    return *max_calory
}

fn part2(calory_per_elf: &Vec<i32>) -> i32 {
    let mut ordered_calory_per_elf = calory_per_elf.clone();
    ordered_calory_per_elf.sort();
    ordered_calory_per_elf.reverse();
    ordered_calory_per_elf.truncate(3);
    return ordered_calory_per_elf.iter().sum::<i32>();
}

fn parse(filename: &str) -> Vec<i32> {
    let file = my_lib::readfile(filename);
    let groups = my_lib::to_group(&file);
    let calory_per_elf: Vec<i32> = groups.iter().map(|group| {
        let group_as_int: Vec<i32> = my_lib::lines_to_int_vec(group);
        let sum_calory: i32 = group_as_int.iter().sum::<i32>();

        return sum_calory;
    }).collect();


    return calory_per_elf;
}

fn main() {
    let example = parse("example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
