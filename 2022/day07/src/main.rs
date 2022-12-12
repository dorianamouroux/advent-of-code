extern crate my_lib;

use std::collections::HashMap;
use std::path::PathBuf;
use itertools::Itertools;

#[derive(Default)]
struct Directory {
    size_files: isize,
    sub_directories: Vec<String>,
}

fn compute_size(result: &mut HashMap<String, isize>, fs: &HashMap<String, Directory>, path: String) -> isize {
    let current_folder = fs.get(&path).unwrap();
    let mut total = current_folder.size_files;

    for sub_dir in &current_folder.sub_directories {
        let path_sub_dir = PathBuf::from(&path).join(sub_dir).to_str().unwrap().to_string();
        total += compute_size(result, fs, path_sub_dir);
    }

    result.insert(path, total);

    total
}

fn part1(fs: &HashMap<String, Directory>) -> isize {
    let mut result = HashMap::new();
    compute_size(&mut result, fs, "/".to_string());

    result.into_iter().map(|(_, size)| size).filter(|size| *size < 100_000).sum::<isize>()
}

fn part2(fs: &HashMap<String, Directory>) -> isize {
    let mut result = HashMap::new();
    let total_size = compute_size(&mut result, fs, "/".to_string());
    let needed_size = (70_000_000 - total_size - 30_000_000).abs();

    result
    .into_iter()
    .map(|(_, size)| size)
    .filter(|size| *size > needed_size)
    .sorted()
    .next()
    .unwrap()
}

fn parse(filename: &str) -> HashMap<String, Directory> {
    let mut graph = HashMap::new();
    let mut current_path = PathBuf::from("/");

    for command in my_lib::readfile(filename).split("$ ").map(str::trim).filter(|line| line.len() > 0) {
        if command.eq("cd /") {
            current_path = PathBuf::from("/");
        }
        else if command.eq("cd ..") {
            current_path.pop();
        }
        else if command.starts_with("cd ") {
            current_path.push(&command[3..]);
        }
        else {
            let current_folder = graph.entry(current_path.to_str().unwrap().to_string()).or_insert_with(|| {
                let sub_directories: Vec<String> = Vec::new();
                Directory { size_files: 0, sub_directories }
            });
            for file in (&command[3..]).split("\n") {
                let (left, right) = file.split_once(" ").unwrap();
                if left == "dir" {
                    current_folder.sub_directories.push(right.to_string());
                } else {
                    let file_size = left.parse::<isize>().unwrap();
                    current_folder.size_files += file_size;
                }
            }
        }
    }

    graph
}

fn main() {
    let example = parse("day07/example.txt");
    println!("part1 example = {}", part1(&example));
    println!("part2 example = {}", part2(&example));

    let input = parse("day07/input.txt");
    println!("part1 input = {}", part1(&input));
    println!("part2 input = {}", part2(&input));
}
