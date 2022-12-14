extern crate my_lib;

#[derive(Debug, PartialEq, Eq)]
enum Packet {
    Number(usize),
    List(Vec<Packet>),
}

fn to_string(p: &Packet) -> String {
    let mut res: String = "".to_owned();

    match p {
        Packet::Number(nb) => res.push_str(&nb.to_string()),
        Packet::List(list) => {
            res.push_str(&"[");
            let packet_as_string: Vec<String> = list.iter().map(|p| to_string(p)).collect();
            let joined = packet_as_string.join(",");
            res.push_str(&joined);
            res.push_str(&"]");
        }
    }

    res
}

fn is_packet_well_ordered(left: &Packet, right: &Packet, nesting: usize) -> Option<bool> {
    for _ in 0..nesting { print!(" "); };
    println!("- Compare {} vs {}", to_string(left), to_string(right));
    match (left, right) {
        (Packet::List(left_packets), Packet::List(right_packets)) => {
            for i in 0..left_packets.len() {
                if i >= right_packets.len() {
                    println!("- Right side ran out of items, so inputs are not in the right order");
                    return Some(false)
                }
                let result = is_packet_well_ordered(&left_packets[i], &right_packets[i], nesting + 1);
                if result != None {
                    return result;
                }
            }
            if left_packets.len() <  right_packets.len() {
                for _ in 0..nesting + 1 { print!(" "); };
                println!("- Left side ran out of items, so inputs are in the right order");
                Some(true)
            } else {
                None
            }
        },
        (Packet::Number(a), Packet::List(_)) => {
            for _ in 0..nesting + 1 { print!(" "); };
            println!("- Mixed types; convert left to [{}] and retry comparison", a);
            is_packet_well_ordered(&Packet::List(vec![Packet::Number(*a)]), right, nesting + 1)
        },
        (Packet::List(_), Packet::Number(b)) => {
            for _ in 0..nesting + 1 { print!(" "); };
            println!("- Mixed types; convert right to [{}] and retry comparison", b);
            is_packet_well_ordered(left, &Packet::List(vec![Packet::Number(*b)]), nesting + 1)
        },
        (Packet::Number(a), Packet::Number(b)) => {
            if a < b {
                for _ in 0..nesting + 1 { print!(" "); };
                println!("- Left side is smaller, so inputs are in the right order");
                Some(true)
            }
            else if a == b { None }
            else {
                for _ in 0..nesting + 1 { print!(" "); };
                println!("- Right side is smaller, so inputs are not in the right order");
                Some(false)
            }
        }
    }
}

fn part1(packet_pairs: &Vec<(Packet, Packet)>) -> usize {
    let mut score = 0;

    for (i, (left, right)) in packet_pairs.iter().enumerate() {
        println!("== Pair {} ==", i + 1);
        if is_packet_well_ordered(left, right, 0).unwrap() {
            score += i + 1;
        }
        println!("");
    }

    score
}

//fn part2(input: &Vec<(Vec<usize>, Vec<usize>)>) -> i32 {
//    6
//}
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
            let char_as_nb = packet_chars[i] as usize - '0' as usize;
            sub_packets.push(Packet::Number(char_as_nb));
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
//    println!("part2 example = {}", part2(&example));

    let input = parse("day13/input.txt");
//    println!("part1 input = {}", part1(&input));
//    println!("part2 input = {}", part2(&input));
}
