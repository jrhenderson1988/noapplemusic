use std::thread::sleep;
use std::time::Duration;

use sysinfo::{Process, ProcessExt, System, SystemExt};

const TARGET_PROCESS: &str = "/system/applications/music.app/contents/macos/music";
const SLEEP_MILLIS: u64 = 2000;

fn main() {
    let mut sys = System::new_all();
    loop {
        for (_pid, process) in sys.processes() {
            if is_target(process) {
                process.kill();
            }
        }

        sleep(Duration::from_millis(SLEEP_MILLIS));
        sys.refresh_processes();
    }
}

fn is_target(process: &Process) -> bool {
    match process.cmd().first() {
        Some(command) => command.to_lowercase().contains(TARGET_PROCESS),
        None => false,
    }
}
