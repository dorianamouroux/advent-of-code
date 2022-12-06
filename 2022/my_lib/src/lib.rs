use std::fs;

pub fn readfile(path: &str) -> String {
    let contents = fs::read_to_string(path)
        .expect("cant read {path}");

    return contents
}

pub fn to_group(content: &str) -> Vec<&str> {
    content.split("\n\n").collect()
}

pub fn lines_to_int_vec(content: &str) -> Vec<i32> {
    content.split("\n").map(|line|
        line.parse().unwrap()
    ).collect()
}
