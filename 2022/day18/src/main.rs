#[macro_use] extern crate scan_fmt;
extern crate my_lib;

type Cube = (i32, i32, i32);


fn is_out_of_bound(current_cube: &Cube, last_cube: &Cube) -> bool {
    // no neg number
    if current_cube.0 < -1 || current_cube.1 < -1 || current_cube.2 < -1 {
        return true;
    }

    // no cube above limit
    if current_cube.0 >= last_cube.0 || current_cube.1 >= last_cube.1 || current_cube.2 >= last_cube.2 {
        return true;
    }

    return false;
}

fn get_neighbors(cube: &Cube) -> Vec<Cube> {
    vec![
        (cube.0 - 1, cube.1, cube.2),
        (cube.0 + 1, cube.1, cube.2),
        (cube.0, cube.1 - 1, cube.2),
        (cube.0, cube.1 + 1, cube.2),
        (cube.0, cube.1, cube.2 - 1),
        (cube.0, cube.1, cube.2 + 1),
    ]
}

fn get_all_air_cubes(air_cubes: &mut Vec<Cube>, lava_cubes: &Vec<Cube>, current_cube: &Cube, last_cube: &Cube) {
    if lava_cubes.contains(current_cube) || air_cubes.contains(current_cube) || is_out_of_bound(current_cube, last_cube) {
        return;
    }
    
    air_cubes.push(*current_cube);

    for neighbor in get_neighbors(current_cube) {
        get_all_air_cubes(air_cubes, lava_cubes, &neighbor, last_cube);
    }
}

fn part1(cubes: &Vec<Cube>) -> i32 {
    cubes.iter().map(|cube| {
        let nb_adjacent_cubes = get_neighbors(cube).iter().filter(|n| cubes.contains(&n)).count();
        6 - nb_adjacent_cubes as i32
    }).sum()
}

fn part2(lava_cubes: &Vec<Cube>) -> i32 {
    let first_air_cube: Cube = (0, 0, 0);
    let last_cube = (
        lava_cubes.iter().map(|c| c.0).max().unwrap() + 2,
        lava_cubes.iter().map(|c| c.1).max().unwrap() + 2,
        lava_cubes.iter().map(|c| c.2).max().unwrap() + 2,
    );
    let mut air_cubes: Vec<Cube> = Vec::new();

    get_all_air_cubes(&mut air_cubes, lava_cubes, &first_air_cube, &last_cube);

    lava_cubes.iter().map(|cube| {
        let nb_adjacent_cubes = get_neighbors(cube).iter().filter(|n| {
            if lava_cubes.contains(&n) {
                return true;
            }
            // if not a known air cube, then it's probably a void air cube
            !air_cubes.contains(&n)
        }).count();
        6 - nb_adjacent_cubes as i32
    }).sum()
}

fn parse(filename: &str) -> Vec<Cube> {
    my_lib::readfile(filename).split("\n").map(|line| {
        scan_fmt!(&line, "{},{},{}", i32, i32, i32).unwrap()
    }).collect()
}

fn main() {
    let example = parse("day18/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day18/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
