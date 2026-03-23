//! I-DeskPet Installer
//!
//! This installer builds the ideskpet CLI binary, clones/updates the repo,
//! and installs everything to the appropriate system locations.
//!
//! Run with `cargo run` on your Arch Linux machine.

#[cfg(unix)]
use std::path::Path;
#[cfg(unix)]
use std::process::{Command, ExitStatus};

#[cfg(unix)]
const REPO_URL: &str = "https://github.com/InoriShio/I-DeskPet";
#[cfg(unix)]
const INSTALL_DIR: &str = "/etc/xdg/quickshell/I-DeskPet";
#[cfg(unix)]
const BINARY_DEST: &str = "/usr/bin/ideskpet";

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
        eprintln!("\x1b[31m[ERROR]\x1b[0m This installer only works on Linux/Unix systems.");
        eprintln!("Please run this on your Arch Linux machine.");
        std::process::exit(1);
    }

    #[cfg(unix)]
    run_installer();
}

#[cfg(unix)]
fn run_installer() {
    println!("{BOLD}=== I-DeskPet Installer ==={NC}\n");

    // Step 1: Build the ideskpet binary
    if !build_binary() {
        std::process::exit(1);
    }

    // Step 2: Clone or update the repository
    if !setup_repository() {
        std::process::exit(1);
    }

    // Step 3: Install the binary to /usr/bin
    if !install_binary() {
        std::process::exit(1);
    }

    // Success!
    println!("\n{GREEN}{BOLD}=== Installation Complete ==={NC}\n");
    print_usage();
}

#[cfg(unix)]
fn build_binary() -> bool {
    println!("{BLUE}[1/3]{NC} Building ideskpet binary...");

    let status = Command::new("cargo")
        .args(["build", "--release", "--bin", "ideskpet"])
        .status();

    match status {
        Ok(s) if s.success() => {
            println!("{GREEN}[OK]{NC} Binary built successfully\n");
            true
        }
        Ok(_) => {
            eprintln!("{RED}[ERROR]{NC} Failed to build binary");
            false
        }
        Err(e) => {
            eprintln!("{RED}[ERROR]{NC} Failed to run cargo: {e}");
            false
        }
    }
}

#[cfg(unix)]
fn setup_repository() -> bool {
    println!("{BLUE}[2/3]{NC} Setting up repository at {INSTALL_DIR}...");

    let install_path = Path::new(INSTALL_DIR);
    let parent_dir = install_path
        .parent()
        .unwrap_or(Path::new("/etc/xdg/quickshell"));

    // Check if parent directory exists, create if not
    if !parent_dir.exists() {
        println!("  Creating directory {parent_dir:?} (requires sudo)...");
        if !run_sudo(&["mkdir", "-p", parent_dir.to_str().unwrap()]) {
            return false;
        }
    }

    if install_path.exists() {
        // Repository exists, do git pull
        println!("  Repository exists, updating with git pull...");
        if !run_sudo(&["git", "-C", INSTALL_DIR, "pull"]) {
            eprintln!("{YELLOW}[WARN]{NC} Git pull failed, continuing anyway...");
        } else {
            println!("{GREEN}[OK]{NC} Repository updated\n");
        }
    } else {
        // Clone the repository
        println!("  Cloning from {REPO_URL}...");
        if !run_sudo(&["git", "clone", REPO_URL, INSTALL_DIR]) {
            eprintln!("{RED}[ERROR]{NC} Failed to clone repository");
            return false;
        }
        println!("{GREEN}[OK]{NC} Repository cloned\n");
    }

    true
}

#[cfg(unix)]
fn install_binary() -> bool {
    println!("{BLUE}[3/3]{NC} Installing binary to {BINARY_DEST}...");

    // Get the path to the built binary
    let binary_src = "target/release/ideskpet";

    if !Path::new(binary_src).exists() {
        eprintln!("{RED}[ERROR]{NC} Built binary not found at {binary_src}");
        return false;
    }

    // Copy binary to /usr/bin
    println!("  Copying binary (requires sudo)...");
    if !run_sudo(&["cp", binary_src, BINARY_DEST]) {
        eprintln!("{RED}[ERROR]{NC} Failed to copy binary");
        return false;
    }

    // Set executable permissions
    println!("  Setting executable permissions...");
    if !run_sudo(&["chmod", "+x", BINARY_DEST]) {
        eprintln!("{RED}[ERROR]{NC} Failed to set permissions");
        return false;
    }

    println!("{GREEN}[OK]{NC} Binary installed to {BINARY_DEST}");
    true
}

#[cfg(unix)]
fn run_sudo(args: &[&str]) -> bool {
    let status = Command::new("sudo").args(args).status();

    matches!(status, Ok(s) if s.success())
}

#[cfg(unix)]
fn print_usage() {
    println!("{BOLD}Usage:{NC}");
    println!("  ideskpet start          Start the desktop pet");
    println!("  ideskpet stop           Stop the desktop pet");
    println!("  ideskpet restart        Restart the desktop pet");
    println!("  ideskpet log            View last 50 lines of logs");
    println!("  ideskpet log -f         Follow logs in real-time");
    println!("  ideskpet log -n <N>     View last N lines of logs");
    println!("  ideskpet update         Update from GitHub");
    println!("  ideskpet toggle-layer   Toggle overlay/bottom layer");
    println!("  ideskpet toggle-region  Toggle click-through mode");
    println!("  ideskpet cycle-zindex   Cycle z-index of hovered gif");
    println!("  ideskpet --help         Show full help");
    println!();
    println!("{BOLD}Get started:{NC}");
    println!("  Run {GREEN}ideskpet start{NC} to launch your desktop pet!");
}
