use std::collections::HashMap;
use std::fs;

use rayon::prelude::*;

#[derive(Debug)]
struct Mapping {
    destination: Vec<(u64, u64, u64)>,
}

impl Mapping {
    fn new(destination: Vec<(u64, u64, u64)>) -> Self {
        Mapping { destination }
    }

    fn map(&self, number: u64) -> u64 {
        for &(dest_start, src_start, length) in &self.destination {
            if number >= src_start && number < src_start + length {
                return dest_start + (number - src_start);
            }
        }
        number
    }
}
fn create_mapping(content: String) -> (Vec<u64>, HashMap<String, Mapping>) {
    let blocks = content.split("\n\n");
    let (_, seeds) = blocks.clone().next().unwrap().split_once(":").unwrap();
    let seeds: Vec<u64> = seeds
        .trim()
        .split_whitespace()
        .map(|x| x.parse().unwrap())
        .collect();

    let mappings = blocks
        .skip(1)
        .map(|block| {
            let mut lines = block.lines();
            let (map_name, _) = lines.next().unwrap().split_once(" ").unwrap();
            let ranges = lines
                .map(|line| {
                    let values = line
                        .split_whitespace()
                        .map(|v| v.parse().unwrap())
                        .collect::<Vec<u64>>();
                    (values[0], values[1], values[2])
                })
                .collect::<Vec<_>>();
            (map_name.to_string(), Mapping::new(ranges))
        })
        .collect::<HashMap<_, _>>();

    (seeds, mappings)
}

pub fn day_5_part_1(file_path: String) -> u64 {
    let content = fs::read_to_string(file_path).expect("Could not read the file");
    let (seeds, mapping) = create_mapping(content);
    let seed_to_soil = mapping.get("seed-to-soil").unwrap();
    let soil_to_fertilizer = mapping.get("soil-to-fertilizer").unwrap();
    let fertilizer_to_water = mapping.get("fertilizer-to-water").unwrap();
    let water_to_light = mapping.get("water-to-light").unwrap();
    let light_to_temperature = mapping.get("light-to-temperature").unwrap();
    let temperature_to_humidity = mapping.get("temperature-to-humidity").unwrap();
    let humidity_to_location = mapping.get("humidity-to-location").unwrap();
    seeds
        .iter()
        .map(|s| seed_to_soil.map(*s))
        .map(|s| soil_to_fertilizer.map(s))
        .map(|f| fertilizer_to_water.map(f))
        .map(|w| water_to_light.map(w))
        .map(|l| light_to_temperature.map(l))
        .map(|t| temperature_to_humidity.map(t))
        .map(|h| humidity_to_location.map(h))
        .min()
        .unwrap()
}

pub fn day_5_part_2(file_path: String) -> u64 {
    let content = fs::read_to_string(file_path).expect("Could not read the file");
    let (seeds, mapping) = create_mapping(content);
    let seeds = seeds
        .chunks_exact(2)
        .flat_map(|chunk| chunk[0]..chunk[0] + chunk[1])
        .collect::<Vec<u64>>();
    let seed_to_soil = mapping.get("seed-to-soil").unwrap();
    let soil_to_fertilizer = mapping.get("soil-to-fertilizer").unwrap();
    let fertilizer_to_water = mapping.get("fertilizer-to-water").unwrap();
    let water_to_light = mapping.get("water-to-light").unwrap();
    let light_to_temperature = mapping.get("light-to-temperature").unwrap();
    let temperature_to_humidity = mapping.get("temperature-to-humidity").unwrap();
    let humidity_to_location = mapping.get("humidity-to-location").unwrap();
    seeds
        .par_iter()
        .map(|s| seed_to_soil.map(*s))
        .map(|s| soil_to_fertilizer.map(s))
        .map(|f| fertilizer_to_water.map(f))
        .map(|w| water_to_light.map(w))
        .map(|l| light_to_temperature.map(l))
        .map(|t| temperature_to_humidity.map(t))
        .map(|h| humidity_to_location.map(h))
        .min()
        .unwrap()
}

fn main() {
    day_5_part_1("2023/5.in".into());
    day_5_part_2("2023/5.in".into());
}
