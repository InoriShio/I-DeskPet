//! I-DeskPet CLI Tool
//!
//! A command-line interface for managing the I-DeskPet desktop pet application.
//!
//! Usage:
//!   ideskpet <command> [options]
//!
//! Commands:
//!   start, stop, restart, log, update, toggle-layer, toggle-region, cycle-zindex

#[cfg(unix)]
use std::env;
#[cfg(unix)]
use std::fs;
#[cfg(unix)]
use std::io::{BufRead, BufReader};
#[cfg(unix)]
use std::path::PathBuf;
#[cfg(unix)]
use std::process::{Command, Stdio};
#[cfg(unix)]
use std::thread;
#[cfg(unix)]
use std::time::Duration;

#[cfg(unix)]
const VERSION: &str = "1.0.0";
#[cfg(unix)]
const APP_ID: &str = "I-DeskPet";
#[cfg(unix)]
const INSTALL_DIR: &str = "/etc/xdg/quickshell/I-DeskPet";
#[cfg(unix)]
const REPO_URL: &str = "https://github.com/InoriShio/I-DeskPet";

// ANSI color codes
#[cfg(unix)]
const RED: &str = "\x1b[31m";
#[cfg(unix)]
const GREEN: &str = "\x1b[32m";
#[cfg(unix)]
const YELLOW: &str = "\x1b[33m";
#[cfg(unix)]
const BLUE: &str = "\x1b[34m";
#[cfg(unix)]
const BOLD: &str = "\x1b[1m";
#[cfg(unix)]
const NC: &str = "\x1b[0m";

fn main() {
    #[cfg(not(unix))]
    {
        eprintln!("\x1b[31m[ERROR]\x1b[0m ideskpet only works on Linux/Unix systems.");
        std::process::exit(1);
    }

    #[cfg(unix)]
    {
        let args: Vec<String> = env::args().collect();
        run_cli(&args);
    }
}

#[cfg(unix)]
fn run_cli(args: &[String]) {
    if args.len() < 2 {
        print_help();
        return;
    }

    let command = args[1].as_str();

    match command {
        "start" => cmd_start(),
        "stop" => cmd_stop(),
        "restart" => cmd_restart(),
        "log" => cmd_log(&args[2..]),
        "update" => cmd_update(),
        "toggle-layer" => cmd_shortcut("toggle-Layer"),
        "toggle-region" => cmd_shortcut("toggle-Region"),
        "cycle-zindex" => cmd_shortcut("cycle-zIndex"),
        "-h" | "--help" | "help" => print_help(),
        "-v" | "--version" | "version" => println!("ideskpet v{VERSION}"),
        _ => {
            eprintln!("{RED}[ERROR]{NC} Unknown command: {command}");
            eprintln!("Run 'ideskpet --help' for usage information.");
            std::process::exit(1);
        }
    }
}

// =============================================================================
// Helper Functions
// =============================================================================

#[cfg(unix)]
fn get_log_dir() -> PathBuf {
    let home = env::var("HOME").unwrap_or_else(|_| "/tmp".to_string());
    PathBuf::from(home).join(".local/state/ideskpet")
}

#[cfg(unix)]
fn get_log_file() -> PathBuf {
    get_log_dir().join("ideskpet.log")
}

#[cfg(unix)]
fn ensure_log_dir() {
    let log_dir = get_log_dir();
    if !log_dir.exists() {
        if let Err(e) = fs::create_dir_all(&log_dir) {
            eprintln!("{YELLOW}[WARN]{NC} Failed to create log directory: {e}");
        }
    }
}

#[cfg(unix)]
fn is_running() -> bool {
    get_pid().is_some()
}

#[cfg(unix)]
fn get_pid() -> Option<u32> {
    let output = Command::new("pgrep")
        .args(["-f", &format!("quickshell.*{APP_ID}")])
        .output()
        .ok()?;

    if output.status.success() {
        let stdout = String::from_utf8_lossy(&output.stdout);
        stdout.lines().next()?.trim().parse().ok()
    } else {
        None
    }
}

#[cfg(unix)]
fn check_dependency(name: &str) -> bool {
    Command::new("which")
        .arg(name)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map(|s| s.success())
        .unwrap_or(false)
}

#[cfg(unix)]
fn check_dependencies() -> bool {
    let mut ok = true;
    let deps = ["quickshell", "hyprctl", "git"];

    for dep in deps {
        if !check_dependency(dep) {
            eprintln!("{RED}[ERROR]{NC} Missing dependency: {dep}");
            ok = false;
        }
    }

    if !ok {
        eprintln!("\nPlease install the missing dependencies and try again.");
    }

    ok
}

// =============================================================================
// Commands
// =============================================================================

#[cfg(unix)]
fn cmd_start() {
    if !check_dependency("quickshell") {
        eprintln!("{RED}[ERROR]{NC} quickshell is not installed");
        std::process::exit(1);
    }

    if is_running() {
        let pid = get_pid().unwrap();
        eprintln!("{YELLOW}[WARN]{NC} I-DeskPet is already running (PID: {pid})");
        eprintln!("Use 'ideskpet restart' to restart, or 'ideskpet stop' to stop.");
        std::process::exit(1);
    }

    // Check if install directory exists
    if !std::path::Path::new(INSTALL_DIR).exists() {
        eprintln!("{RED}[ERROR]{NC} I-DeskPet is not installed at {INSTALL_DIR}");
        eprintln!("Please run the installer first: cargo run");
        std::process::exit(1);
    }

    ensure_log_dir();
    let log_file = get_log_file();

    println!("{GREEN}[INFO]{NC} Starting I-DeskPet...");

    // Open log file for appending
    let log_handle = fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(&log_file);

    let (stdout_file, stderr_file) = match log_handle {
        Ok(f) => {
            let f2 = f.try_clone().unwrap_or_else(|_| {
                fs::OpenOptions::new()
                    .create(true)
                    .append(true)
                    .open(&log_file)
                    .unwrap()
            });
            (Stdio::from(f), Stdio::from(f2))
        }
        Err(e) => {
            eprintln!("{YELLOW}[WARN]{NC} Could not open log file: {e}");
            (Stdio::null(), Stdio::null())
        }
    };

    // Spawn quickshell process
    let result = Command::new("nohup")
        .args(["quickshell", "-p", INSTALL_DIR])
        .stdout(stdout_file)
        .stderr(stderr_file)
        .stdin(Stdio::null())
        .spawn();

    match result {
        Ok(_child) => {
            // Wait a moment to check if it started
            thread::sleep(Duration::from_secs(1));

            if is_running() {
                let pid = get_pid().unwrap_or(0);
                println!("{GREEN}[OK]{NC} I-DeskPet started successfully (PID: {pid})");
                println!("Use 'ideskpet log -f' to view logs");
            } else {
                eprintln!("{RED}[ERROR]{NC} I-DeskPet failed to start");
                eprintln!("Check logs with 'ideskpet log' for details");
                std::process::exit(1);
            }
        }
        Err(e) => {
            eprintln!("{RED}[ERROR]{NC} Failed to start quickshell: {e}");
            std::process::exit(1);
        }
    }
}

#[cfg(unix)]
fn cmd_stop() {
    if !is_running() {
        println!("{YELLOW}[WARN]{NC} I-DeskPet is not running");
        return;
    }

    let pid = get_pid().unwrap();
    println!("{GREEN}[INFO]{NC} Stopping I-DeskPet (PID: {pid})...");

    // Send SIGTERM
    let _ = Command::new("kill").arg(pid.to_string()).status();

    // Wait for graceful shutdown (up to 5 seconds)
    for _ in 0..10 {
        thread::sleep(Duration::from_millis(500));
        if !is_running() {
            println!("{GREEN}[OK]{NC} I-DeskPet stopped successfully");
            return;
        }
    }

    // Force kill if still running
    println!("{YELLOW}[WARN]{NC} Graceful shutdown failed, force killing...");
    let _ = Command::new("kill").args(["-9", &pid.to_string()]).status();

    thread::sleep(Duration::from_millis(500));

    if is_running() {
        eprintln!("{RED}[ERROR]{NC} Failed to stop I-DeskPet");
        std::process::exit(1);
    } else {
        println!("{GREEN}[OK]{NC} I-DeskPet stopped successfully");
    }
}

#[cfg(unix)]
fn cmd_restart() {
    println!("{GREEN}[INFO]{NC} Restarting I-DeskPet...");

    if is_running() {
        cmd_stop();
    }

    thread::sleep(Duration::from_millis(500));
    cmd_start();
}

#[cfg(unix)]
fn cmd_log(args: &[String]) {
    let log_file = get_log_file();

    if !log_file.exists() {
        eprintln!(
            "{YELLOW}[WARN]{NC} No log file found at {}",
            log_file.display()
        );
        eprintln!("Start I-DeskPet first with 'ideskpet start'");
        std::process::exit(1);
    }

    let mut follow = false;
    let mut lines: u32 = 50;

    // Parse arguments
    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "-f" | "--follow" => {
                follow = true;
            }
            "-n" | "--lines" => {
                if i + 1 < args.len() {
                    if let Ok(n) = args[i + 1].parse() {
                        lines = n;
                        i += 1;
                    } else {
                        eprintln!("{RED}[ERROR]{NC} Invalid number for -n option");
                        std::process::exit(1);
                    }
                } else {
                    eprintln!("{RED}[ERROR]{NC} -n option requires a number");
                    std::process::exit(1);
                }
            }
            _ => {
                eprintln!("{RED}[ERROR]{NC} Unknown log option: {}", args[i]);
                eprintln!("Usage: ideskpet log [-f] [-n <lines>]");
                std::process::exit(1);
            }
        }
        i += 1;
    }

    if follow {
        println!("{GREEN}[INFO]{NC} Following logs (Ctrl+C to exit)...");
        println!("---");

        let status = Command::new("tail")
            .args(["-n", &lines.to_string(), "-f", log_file.to_str().unwrap()])
            .status();

        if let Err(e) = status {
            eprintln!("{RED}[ERROR]{NC} Failed to tail log file: {e}");
            std::process::exit(1);
        }
    } else {
        let status = Command::new("tail")
            .args(["-n", &lines.to_string(), log_file.to_str().unwrap()])
            .status();

        if let Err(e) = status {
            eprintln!("{RED}[ERROR]{NC} Failed to read log file: {e}");
            std::process::exit(1);
        }
    }
}

#[cfg(unix)]
fn cmd_update() {
    if !check_dependency("git") {
        eprintln!("{RED}[ERROR]{NC} git is not installed");
        std::process::exit(1);
    }

    if !std::path::Path::new(INSTALL_DIR).exists() {
        eprintln!("{RED}[ERROR]{NC} I-DeskPet is not installed at {INSTALL_DIR}");
        eprintln!("Please run the installer first: cargo run");
        std::process::exit(1);
    }

    println!("{GREEN}[INFO]{NC} Updating I-DeskPet from GitHub...");

    let status = Command::new("sudo")
        .args(["git", "-C", INSTALL_DIR, "pull"])
        .status();

    match status {
        Ok(s) if s.success() => {
            println!("{GREEN}[OK]{NC} Update completed successfully");

            if is_running() {
                println!();
                println!("{YELLOW}[WARN]{NC} I-DeskPet is currently running.");
                println!("Run 'ideskpet restart' to apply changes.");
            }
        }
        Ok(_) => {
            eprintln!("{RED}[ERROR]{NC} Git pull failed");
            std::process::exit(1);
        }
        Err(e) => {
            eprintln!("{RED}[ERROR]{NC} Failed to run git: {e}");
            std::process::exit(1);
        }
    }
}

#[cfg(unix)]
fn cmd_shortcut(shortcut: &str) {
    if !check_dependency("hyprctl") {
        eprintln!("{RED}[ERROR]{NC} hyprctl not found. Are you running Hyprland?");
        std::process::exit(1);
    }

    if !is_running() {
        eprintln!("{YELLOW}[WARN]{NC} I-DeskPet is not running");
        eprintln!("Start it first with 'ideskpet start'");
        std::process::exit(1);
    }

    let shortcut_full = format!("{APP_ID}:{shortcut}");
    println!("{GREEN}[INFO]{NC} Triggering shortcut: {shortcut_full}");

    let status = Command::new("hyprctl")
        .args(["dispatch", "global", &shortcut_full])
        .status();

    match status {
        Ok(s) if s.success() => {
            println!("{GREEN}[OK]{NC} Shortcut triggered");
        }
        Ok(_) => {
            eprintln!("{RED}[ERROR]{NC} Failed to trigger shortcut");
            std::process::exit(1);
        }
        Err(e) => {
            eprintln!("{RED}[ERROR]{NC} Failed to run hyprctl: {e}");
            std::process::exit(1);
        }
    }
}

#[cfg(unix)]
fn print_help() {
    println!(
        "{BOLD}ideskpet{NC} - CLI tool for I-DeskPet desktop pet application (v{VERSION})

{BOLD}USAGE:{NC}
    ideskpet <COMMAND> [OPTIONS]

{BOLD}COMMANDS:{NC}
    {GREEN}start{NC}              Start the I-DeskPet application
    {GREEN}stop{NC}               Stop the running I-DeskPet instance
    {GREEN}restart{NC}            Restart the I-DeskPet application
    {GREEN}log{NC}                Show application logs
    {GREEN}update{NC}             Update I-DeskPet from GitHub

{BOLD}HYPRLAND SHORTCUTS:{NC}
    {BLUE}toggle-layer{NC}       Toggle pet between overlay/bottom layer
    {BLUE}toggle-region{NC}      Toggle click-through mode
    {BLUE}cycle-zindex{NC}       Cycle z-index of hovered gif

{BOLD}LOG OPTIONS:{NC}
    ideskpet log           Show last 50 lines of logs
    ideskpet log -f        Follow logs in real-time (Ctrl+C to exit)
    ideskpet log -n <N>    Show last N lines of logs

{BOLD}OTHER:{NC}
    -h, --help         Show this help message
    -v, --version      Show version

{BOLD}CONFIGURATION:{NC}
    User config: ~/.config/I-DeskPet/config.json

    Example config.json:
    {{
      \"gifFolder\": \"/home/user/Pictures/Pets\",
      \"maxScaling\": 1
    }}

{BOLD}HYPRLAND KEYBIND EXAMPLES:{NC}
    bind = CTRL, mouse:274, global, I-DeskPet:toggle-Region
    bind = SHIFT, mouse:274, global, I-DeskPet:toggle-Layer
    bind = $mainMod, Z, global, I-DeskPet:cycle-zIndex

{BOLD}OTHER KEYBINDS:{NC}
    Double click   Reset gif size to original
    Scroll         Scale the gif up or down
"
    );
}
