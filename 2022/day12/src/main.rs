extern crate my_lib;

use pathfinding::prelude::dijkstra;

#[derive(Clone, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Copy)]
struct Pos(usize, usize);

fn find_chars_in_map(map: &Vec<Vec<char>>, c: char) -> Vec<Pos> {
    let mut res = Vec::new();

    for y in 0..map.len() {
        for x in 0..map[y].len() {
            if map[y][x] == c {
                res.push(Pos(x, y))
            }
        }
    }
    res
}

fn get_char_at(map: &Vec<Vec<char>>, pos: &Pos) -> char {
    let current_cell = map[pos.1][pos.0];

    match current_cell {
        'S' => 'a',
        'E' => 'z',
        letter => letter
    }
}

fn find_possible_steps(map: &Vec<Vec<char>>, pos: &Pos) -> Vec<(Pos, usize)> {
    let width = map[0].len();
    let height = map.len();
    let current_cell = get_char_at(map, pos) as i32;

    let mut neighbors: Vec<Pos> = Vec::new();

    if pos.0 > 0 { neighbors.push(Pos(pos.0 - 1, pos.1)); } // left
    if pos.0 < width - 1 { neighbors.push(Pos(pos.0 + 1, pos.1)); } // right
    if pos.1 > 0 { neighbors.push(Pos(pos.0, pos.1 - 1)); } // top
    if pos.1 < height - 1 { neighbors.push(Pos(pos.0, pos.1 + 1)); } // bottom

    neighbors.into_iter().filter(|dest_cell| {
        let elem = get_char_at(map, dest_cell) as i32;
        elem - current_cell <= 1
    }).map(|pos| (pos, 1)).collect()
}

fn resolve_at_start_pos(map: &Vec<Vec<char>>, start: &Pos) -> Option<(Vec<Pos>, usize)> {
    let end = find_chars_in_map(map, 'E')[0];

    dijkstra(start, |p| {
        let neighbors = find_possible_steps(map, p);
        neighbors.into_iter()
    }, |p| *p == end)
}

fn part1(map: &Vec<Vec<char>>) -> usize {
    let start = find_chars_in_map(map, 'S')[0];
    resolve_at_start_pos(map, &start).unwrap().1
}

fn part2(map: &Vec<Vec<char>>) -> usize {
    let mut real_start = find_chars_in_map(map, 'S');
    let mut all_starting_pos = find_chars_in_map(map, 'a');
    all_starting_pos.append(&mut real_start);

    all_starting_pos.into_iter()
        .map(|start| resolve_at_start_pos(map, &start))
        .filter(|v| {
            match v {
                None => false,
                Some(_) => true,
            }
        })
        .map(|v| v.unwrap().1)
        .min()
        .unwrap()
}

fn parse(filename: &str) -> Vec<Vec<char>> {
    my_lib::readfile(filename).split("\n").map(|line| {
        line.chars().collect()
    }).collect()
}

fn main() {
    let example = parse("day12/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day12/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
