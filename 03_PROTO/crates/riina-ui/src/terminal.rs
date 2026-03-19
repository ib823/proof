//! Terminal renderer — ANSI escape code backend.

use crate::sinar::Renderer;

/// A renderer that outputs ANSI-colored terminal text.
pub struct TerminalRenderer {
    output: String,
}

impl TerminalRenderer {
    pub fn new() -> Self {
        Self { output: String::new() }
    }
}

impl Default for TerminalRenderer {
    fn default() -> Self {
        Self::new()
    }
}

impl Renderer for TerminalRenderer {
    fn render_text(&mut self, text: &str, color: (u8, u8, u8)) {
        self.output.push_str(&format!(
            "\x1b[38;2;{};{};{}m{}\x1b[0m",
            color.0, color.1, color.2, text
        ));
    }

    fn render_rect(&mut self, x: u32, y: u32, w: u32, h: u32, color: (u8, u8, u8)) {
        self.output.push_str(&format!(
            "\x1b[48;2;{};{};{}m[rect {x},{y} {w}x{h}]\x1b[0m",
            color.0, color.1, color.2
        ));
    }

    fn begin_row(&mut self) {
        self.output.push_str("[row:");
    }

    fn end_row(&mut self) {
        self.output.push(']');
    }

    fn begin_column(&mut self) {
        self.output.push_str("[col:");
    }

    fn end_column(&mut self) {
        self.output.push(']');
    }

    fn output(&self) -> &str {
        &self.output
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn terminal_text_ansi_fg() {
        let mut r = TerminalRenderer::new();
        r.render_text("hello", (255, 0, 0));
        assert!(r.output().contains("\x1b[38;2;255;0;0m"));
        assert!(r.output().contains("hello"));
        assert!(r.output().contains("\x1b[0m"));
    }

    #[test]
    fn terminal_rect_ansi_bg() {
        let mut r = TerminalRenderer::new();
        r.render_rect(10, 20, 100, 50, (0, 255, 0));
        assert!(r.output().contains("\x1b[48;2;0;255;0m"));
    }

    #[test]
    fn terminal_row_markers() {
        let mut r = TerminalRenderer::new();
        r.begin_row();
        r.render_text("item", (255, 255, 255));
        r.end_row();
        assert!(r.output().starts_with("[row:"));
        assert!(r.output().ends_with(']'));
    }

    #[test]
    fn terminal_column_markers() {
        let mut r = TerminalRenderer::new();
        r.begin_column();
        r.render_text("item", (255, 255, 255));
        r.end_column();
        assert!(r.output().starts_with("[col:"));
        assert!(r.output().ends_with(']'));
    }

    #[test]
    fn terminal_default() {
        let r = TerminalRenderer::default();
        assert_eq!(r.output(), "");
    }
}
