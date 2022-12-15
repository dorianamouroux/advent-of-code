use std::cmp::Ordering;

extern crate my_lib;

#[derive(Debug, PartialEq, Eq)]
enum Packet {
    Number(i32),
    List(Vec<Packet>),
}

fn compare(left: &Packet, right: &Packet) -> Ordering {
    match (left, right) {
        (Packet::List(left_packets), Packet::List(right_packets)) => {
            for (a, b) in left_packets.iter().zip(right_packets.iter()) {
                let res = compare(a, b);
                if res != Ordering::Equal {
                    return res
                }
            }
            return left_packets.len().cmp(&right_packets.len())
        },
        (Packet::Number(a), Packet::List(_)) => compare(&Packet::List(vec![Packet::Number(*a)]), right),
        (Packet::List(_), Packet::Number(b)) => compare(left, &Packet::List(vec![Packet::Number(*b)])),
        (Packet::Number(a), Packet::Number(b)) => a.cmp(b),
    }
}

fn part1(packet_pairs: &Vec<(Packet, Packet)>) -> usize {
    packet_pairs.iter().enumerate().map(|(i, (left, right))| {
        if compare(left, right) == Ordering::Less {i + 1} else { 0 }
    }).sum()
}


fn part2(input: &Vec<(Packet, Packet)>) -> usize {
    let first_divider = parse_packet("[[2]]");
    let second_divider = parse_packet("[[6]]");
    let mut all_packets: Vec<&Packet> = input.iter().map(|(l, r)| Vec::from([l, r])).flatten().collect::<Vec<&Packet>>();
    all_packets.push(&first_divider);
    all_packets.push(&second_divider);
    all_packets.sort_by(|a, b| compare(a, b));

    let first_divider_pos = all_packets.iter().position(|p| **p == first_divider).unwrap() + 1;
    let second_divider_pos = all_packets.iter().position(|p| **p == second_divider).unwrap() + 1;

    first_divider_pos * second_divider_pos
}


fn find_matching_bracket(packet: &str, pos: usize) -> usize {
    let packet_chars: Vec<char> = packet.chars().collect();
    let mut opening_bracking = 0;
    for i in (pos + 1)..packet.len() {
        if packet_chars[i] == '[' {
            opening_bracking += 1;
        }
        if packet_chars[i] == ']' {
            if opening_bracking == 0 {
                return i
            } else {
                opening_bracking -= 1
            }
        }
    }
    panic!("bad input");
}

fn find_matching_number(packet: &str, pos: usize) -> usize {
    let packet_chars: Vec<char> = packet.chars().collect();
    for i in (pos + 1)..packet.len() {
        if !packet_chars[i].is_numeric() {
            return i
        }
    }
    panic!("bad input");
}

fn parse_packet(packet: &str) -> Packet {
    let mut sub_packets = Vec::new();
    let packet_chars: Vec<char> = packet.chars().collect();
    let mut i = 1;
    while i < packet_chars.len() {
        if packet_chars[i] == '[' {
            let pos_end_packet = find_matching_bracket(packet, i);
            let captured_packet = &packet[i..pos_end_packet + 1];
            sub_packets.push(parse_packet(captured_packet));
            i = pos_end_packet;
        } else if packet_chars[i].is_numeric() {
            let pos_end_number = find_matching_number(packet, i);
            let captured_packet = &packet[i..pos_end_number];
            sub_packets.push(Packet::Number(captured_packet.parse::<i32>().unwrap()));
            i = pos_end_number;
        }
        i += 1;
    }
    return Packet::List(sub_packets)
}

fn parse(filename: &str) -> Vec<(Packet, Packet)> {
    let file = my_lib::readfile(filename);
    let groups = my_lib::to_group(&file);

    groups.into_iter().map(|pair| {
        let (left, right) = pair.split_once("\n").unwrap();
        (parse_packet(left), parse_packet(right))
    }).collect()
}

fn main() {
    let example = parse("day13/example.txt");
    println!("part1 example = {}", part1(&example));
   println!("part2 example = {}", part2(&example));

    let input = parse("day13/input.txt");
    println!("part1 input = {}", part1(&input));
   println!("part2 input = {}", part2(&input));
}
