extern crate my_lib;

use std::collections::HashMap;

#[derive(Debug, PartialEq)]
enum Material {
    Sand,
    Rock
}
type Point = (i32, i32);
type Terrain = HashMap<Point, Material>;

fn drop_sand(terrain: &mut Terrain, from_point: &Point, lowest_rock: i32, has_floor: bool) -> bool {
    // checking if we fell lower than anything, then we can stop
    if from_point.1 > lowest_rock && !has_floor || terrain.get(&from_point) != None {
        return false;
    }

    let pos_to_try = vec![
    (from_point.0, from_point.1 + 1), // under
    (from_point.0 - 1, from_point.1 + 1), // under left
    (from_point.0 + 1, from_point.1 + 1), // under right
    ];

    for pos in pos_to_try {
        if pos.1 >= lowest_rock + 2 {
            break;
        }
        if terrain.get(&pos) == None {
            return drop_sand(terrain, &pos, lowest_rock, has_floor);
        }
    }

    terrain.insert(*from_point, Material::Sand);
    return true;
}

fn get_lowest_point(terrain: &Terrain) -> i32 {
    let all_pos: Vec<Point> = terrain.keys().map(|f| *f).collect();
    all_pos.iter().map(|point| point.1).max().unwrap()
}

fn count_sand(terrain: &Terrain) -> usize {
    terrain.values().filter(|m| **m == Material::Sand).count()
}

fn part1(terrain: &mut Terrain) -> usize {
    let lowest_point = get_lowest_point(terrain);
    while drop_sand(terrain, &(500, 0), lowest_point, false) {}
    count_sand(terrain)
}

fn part2(terrain: &mut Terrain) -> usize {
    let lowest_point = get_lowest_point(terrain);
    while drop_sand(terrain, &(500, 0), lowest_point, true) {}
    count_sand(terrain)
}

fn draw_line(map: &mut Terrain, from: &Point, to: &Point) {
    let (start_x, end_x) = if from.0 < to.0 { (from.0, to.0) } else { (to.0, from.0) };
    let (start_y, end_y) = if from.1 < to.1 { (from.1, to.1) } else { (to.1, from.1) };

    for x in start_x..end_x + 1 {
        for y in start_y..end_y + 1 {
            map.insert((x, y), Material::Rock);
        }
    }
}

fn parse_point(point: &String) -> Point {
    let (x, y) = point.split_once(",").unwrap();
    (x.parse::<i32>().unwrap(), y.parse::<i32>().unwrap())
}

fn parse(filename: &str) -> Terrain {
    let mut map: Terrain = HashMap::new();
    let lines: Vec<String> = my_lib::readfile(filename).split("\n").map(str::to_string).collect();

    for line in lines {
        let points: Vec<String> = line.split(" -> ").map(str::to_string).collect();
        for i in 0..points.len() - 1 {
            draw_line(&mut map, &parse_point(&points[i]), &parse_point(&points[i + 1]))
        }
    }

    map
}

fn main() {
    let mut example = parse("day14/example.txt");
    println!("part1 example = {}", part1(&mut example));
    println!("part2 example = {}", part2(&mut example));

    let mut input = parse("day14/input.txt");
    println!("part1 input = {}", part1(&mut input));
    println!("part2 input = {}", part2(&mut input));
}