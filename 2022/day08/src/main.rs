extern crate my_lib;

#[derive(Debug)]
pub struct Tree {
    height: i32,
    visible: bool,
}

pub type Forest = Vec<Vec<Tree>>;

struct Pos(usize, usize);

fn look_right(forest: &mut Forest, from_pos: &Pos) -> i32 {
    let mut nb_tree_encountered = 0;
    let tree_where_i_sit = &forest[from_pos.1][from_pos.0].height;

    for x in (from_pos.0 + 1)..forest[0].len() {
        let tree = &forest[from_pos.1][x];
        nb_tree_encountered += 1;
        if tree.height >= *tree_where_i_sit {
            break;
        }
    }

    nb_tree_encountered
}

fn look_left(forest: &mut Forest, from_pos: &Pos) -> i32 {
    let mut nb_tree_encountered = 0;
    let tree_where_i_sit = &forest[from_pos.1][from_pos.0].height;

    for x in (0..from_pos.0).rev() {
        let tree = &forest[from_pos.1][x];
        nb_tree_encountered += 1;
        if tree.height >= *tree_where_i_sit {
            break;
        }
    }

    nb_tree_encountered
}

fn look_up(forest: &mut Forest, from_pos: &Pos) -> i32 {
    let mut nb_tree_encountered = 0;
    let tree_where_i_sit = &forest[from_pos.1][from_pos.0].height;

    for y in (0..from_pos.1).rev() {
        let tree = &forest[y][from_pos.0];
        nb_tree_encountered += 1;
        if tree.height >= *tree_where_i_sit {
            break;
        }
    }

    nb_tree_encountered
}

fn look_down(forest: &mut Forest, from_pos: &Pos) -> i32 {
    let mut nb_tree_encountered = 0;
    let tree_where_i_sit = &forest[from_pos.1][from_pos.0].height;

    for y in (from_pos.1 + 1)..forest.len() {
        let tree = &forest[y][from_pos.0];
        nb_tree_encountered += 1;
        if tree.height >= *tree_where_i_sit {
            break;
        }
    }

    nb_tree_encountered
}

fn from_left(forest: &mut Forest) {
    for tree_line in forest {
        let mut current_height = -1;
        for tree in tree_line {
            if tree.height > current_height {
                tree.visible = true;
                current_height = tree.height;
            }
        }
    }
}


fn from_right(forest: &mut Forest) {
    for tree_line in forest {
        let mut current_height = -1;
        for tree in tree_line.iter_mut().rev() {
            if tree.height > current_height {
                tree.visible = true;
                current_height = tree.height;
            }
        }
    }
}

fn from_top(forest: &mut Forest) {
    let width = forest[0].len();
    let height = forest.len();

    for x in 0..width {
        let mut current_height = -1;
        for y in 0..height {
            let mut tree = &mut forest[y][x];
            if tree.height > current_height {
                tree.visible = true;
                current_height = tree.height;
            }
        }
    }
}


fn from_bottom(forest: &mut Forest) {
    let width = forest[0].len();
    let height = forest.len();

    for x in 0..width {
        let mut current_height = -1;
        for y in (0..height).rev() {
            let mut tree = &mut forest[y][x];
            if tree.height > current_height {
                tree.visible = true;
                current_height = tree.height;
            }
        }
    }
}

fn nb_visible(forest: &Forest) -> i32 {
    let mut nb_visible = 0;

    for tree_line in forest {
        for tree in tree_line {
            if tree.visible {
                nb_visible += 1;
            }
        }
    }

    return nb_visible;
}


fn part1(forest: &mut Forest) -> i32 {
    from_left(forest);
    from_top(forest);
    from_bottom(forest);
    from_right(forest);

    nb_visible(forest)
}

fn part2(forest: &mut Forest) -> i32 {
    let width = forest[0].len();
    let height = forest.len();
    let mut highest_score = -1;

    for x in 0..width {
        for y in 0..height {
            let score = look_right(forest, &Pos(x, y)) * look_left(forest, &Pos(x, y))  * look_up(forest, &Pos(x, y)) * look_down(forest, &Pos(x, y));
            if score > highest_score {
                highest_score = score
            }
        }
    }

    highest_score
}

fn parse(filename: &str) -> Forest {
    my_lib::readfile(filename).split("\n").map(|line| {
        line.chars().map(|cell| {
            let height = cell as i32 - '0' as i32;
            Tree { height: height, visible: false}
        }).collect()
    }).collect()
}

fn main() {
    let mut example = parse("day08/example.txt");
    println!("part1 example = {}", part1(&mut example));
    println!("part2 example = {}", part2(&mut example));

    let mut input = parse("day08/input.txt");
    println!("part1 input = {}", part1(&mut input));
    println!("part2 input = {}", part2(&mut input));
}
