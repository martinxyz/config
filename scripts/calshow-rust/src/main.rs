use std::{fs::File, io::BufReader, time::{Duration}};
use std::io::prelude::*;
use std::env;
use std::path::Path;

fn main() -> std::io::Result<()> {
    let interval_secs = 60*60*9;
    
    let path_base = Path::new(&env::var("HOME").unwrap()).join(".caldav-remind");
    let path_last_shown = path_base.join("last-shown");
    
    let showtime = match path_last_shown.metadata() {
        Err(_) => true,
        Ok(metadata) => match metadata.modified()?.elapsed() {
            Err(_) => true,
            Ok(duration) => duration >= Duration::from_secs(interval_secs),
        },
    };
    
    if showtime {
        // read-only text file, synced via caldav
        let file = File::open(path_base.join("content"))?;
        let reader = BufReader::new(file);
        let lines = reader.lines()
            .map(|s| String::from(s.unwrap_or(String::from("???")).trim()))
            .filter(|s| !s.is_empty())
            .take(3)
            .collect::<Vec<_>>();

        // calendar not empty
        if !lines.is_empty() {
            eprintln!();
            for line in lines {
                eprintln!("{}", &line.chars().take(80).collect::<String>());
            }
            eprintln!();
            // touch or create
            File::create(path_last_shown).ok();
        }
    }
    Ok(())
}
