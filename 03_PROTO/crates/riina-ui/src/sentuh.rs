//! SENTUH — Input handling.
//!
//! Types for representing user input events.

/// A keyboard key.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Key {
    Char(char),
    Enter,
    Escape,
    Tab,
    Backspace,
    Arrow(Direction),
}

/// A direction for arrow keys and navigation.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

/// Modifier keys held during an input event.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub struct Modifiers {
    pub ctrl: bool,
    pub alt: bool,
    pub shift: bool,
}

/// An input event from the user.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum InputEvent {
    KeyPress(Key, Modifiers),
    MouseClick { x: u32, y: u32 },
    MouseMove { x: u32, y: u32 },
}

/// Check if an input event matches a key with modifiers.
pub fn matches_shortcut(event: &InputEvent, key: Key, modifiers: Modifiers) -> bool {
    matches!(event, InputEvent::KeyPress(k, m) if *k == key && *m == modifiers)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn shortcut_match() {
        let event = InputEvent::KeyPress(
            Key::Char('s'),
            Modifiers { ctrl: true, alt: false, shift: false },
        );
        assert!(matches_shortcut(
            &event,
            Key::Char('s'),
            Modifiers { ctrl: true, alt: false, shift: false },
        ));
    }

    #[test]
    fn shortcut_no_match_different_key() {
        let event = InputEvent::KeyPress(
            Key::Char('s'),
            Modifiers { ctrl: true, alt: false, shift: false },
        );
        assert!(!matches_shortcut(
            &event,
            Key::Char('x'),
            Modifiers { ctrl: true, alt: false, shift: false },
        ));
    }

    #[test]
    fn shortcut_no_match_mouse_event() {
        let event = InputEvent::MouseClick { x: 10, y: 20 };
        assert!(!matches_shortcut(
            &event,
            Key::Char('s'),
            Modifiers::default(),
        ));
    }
}
