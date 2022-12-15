use input::{
    event::{switch::SwitchState, SwitchEvent},
    Libinput, LibinputInterface,
};
use std::{
    fs::{File, OpenOptions},
    os::unix::{
        fs::OpenOptionsExt,
        io::{FromRawFd, IntoRawFd, RawFd},
    },
    path::Path,
    process::Command,
};

// Setup boilerplate to allow libinput to talk to /dev/input
struct Interface;
impl LibinputInterface for Interface {
    fn open_restricted(&mut self, path: &Path, flags: i32) -> Result<RawFd, i32> {
        OpenOptions::new()
            .custom_flags(flags)
            .read(true)
            .open(path)
            .map(|file| file.into_raw_fd())
            .map_err(|err| err.raw_os_error().unwrap())
    }
    fn close_restricted(&mut self, fd: RawFd) {
        unsafe {
            File::from_raw_fd(fd);
        }
    }
}

fn set_tablet_mode(tablet_mode: bool) {
    // Set screen keyboard
    Command::new("dconf")
        .arg("write")
        .arg("/org/gnome/desktop/a11y/applications/screen-keyboard-enabled")
        .arg(tablet_mode.to_string())
        .spawn()
        .expect("write screen kb state");
}

fn main() {
    // Disable tablet mode on default
    set_tablet_mode(false);
    // Connect to libinput
    let mut input = Libinput::new_with_udev(Interface);
    input.udev_assign_seat("seat0").unwrap();
    // Wait for an input to happen
    loop {
        input.dispatch().unwrap();
        for event in &mut input {
            match event {
                input::Event::Switch(SwitchEvent::Toggle(switch_toggle)) => {
                    if switch_toggle.switch() == Some(input::event::switch::Switch::TabletMode) {
                        set_tablet_mode(switch_toggle.switch_state() == SwitchState::On);
                    }
                }
                _ => {}
            }
        }
        // Sleep for 300ms
        std::thread::sleep(std::time::Duration::from_millis(300));
    }
}
