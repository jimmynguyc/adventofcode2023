use indicatif::ProgressBar;
use std::collections::HashMap;
use std::fs;

#[derive(Default)]
struct Almanac {
    ranges: Vec<(usize, usize, usize)>,
}

impl Almanac {
    fn convert(&self, source: usize) -> usize {
        if let Some((range_start, _range_end, dest_start)) = self
            .ranges
            .iter()
            .find(|&&(start, end, _)| start <= source && source < end)
        {
            dest_start + (source - range_start)
        } else {
            source
        }
    }
}

fn main() {
    /*
    let input = r#"
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
    "#;
    */
    let input = match fs::read_to_string("input") {
        Ok(content) => content,
        Err(e) => {
            eprintln!("Error reading file: {}", e);
            return;
        }
    };
    let categories: Vec<&str> = input.split("\n\n").collect();

    let seed_range_values = categories[0].split(":").nth(1).unwrap().trim();
    let seed_ranges: Vec<String> = seed_range_values 
        .split_whitespace()
        .collect::<Vec<&str>>()
        .chunks(2)
        .map(|chunk| chunk.join(" "))
        .collect();


    let mut category_maps: HashMap<&str, Almanac> = HashMap::new();

    for cat in categories.iter().skip(1) {
        let cat_input: Vec<&str> = cat.trim().lines().collect();
        let conversion = cat_input[0].trim_end_matches(" map:").trim();
        let mut cat_almanac = Almanac::default();

        for line in cat_input.iter().skip(1) {
            let values: Vec<usize> = line.trim().split_whitespace().map(|s| s.parse().unwrap()).collect();
            cat_almanac.ranges.push((values[1], values[1] + values[2], values[0]));
        }

        category_maps.insert(conversion, cat_almanac);
    }

    let mut total_seeds: u64 = 0;
    for seed_range in seed_ranges.iter() {
        let values: Vec<usize> = seed_range.split_whitespace().map(|s| s.parse().unwrap()).collect();
        let length = values[1] as u64;

        total_seeds += length;
    }

    let pb = ProgressBar::new(total_seeds);
    let mut min = usize::MAX;
    let mut count = 0;

    for seed_range in seed_ranges.iter() {
        let values: Vec<usize> = seed_range.split_whitespace().map(|s| s.parse().unwrap()).collect();
        let start = values[0];
        let length = values[1];

        for seed in start..start + length {
            let mut location = seed;

            for conversion in &["seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"] {
                location = category_maps[conversion].convert(location);
            }

            count += 1;
            pb.set_position(count);
            min = min.min(location);
        }
    }

    println!("\n{}", min);
}
