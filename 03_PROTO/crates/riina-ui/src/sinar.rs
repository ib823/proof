//! SINAR — Rendering backend abstraction.
//!
//! Defines the `Renderer` trait that all rendering backends must implement.

/// Trait for rendering backends (terminal, HTML, GPU, etc.).
pub trait Renderer {
    /// Render text at the current position with the given foreground color.
    fn render_text(&mut self, text: &str, color: (u8, u8, u8));

    /// Render a filled rectangle at (x, y) with dimensions (w, h).
    fn render_rect(&mut self, x: u32, y: u32, w: u32, h: u32, color: (u8, u8, u8));

    /// Begin a horizontal row layout context.
    fn begin_row(&mut self);

    /// End a horizontal row layout context.
    fn end_row(&mut self);

    /// Begin a vertical column layout context.
    fn begin_column(&mut self);

    /// End a vertical column layout context.
    fn end_column(&mut self);

    /// Get the accumulated output (for testing and serialization).
    fn output(&self) -> &str;
}

#[cfg(test)]
mod tests {
    use super::*;

    struct NullRenderer;

    impl Renderer for NullRenderer {
        fn render_text(&mut self, _text: &str, _color: (u8, u8, u8)) {}
        fn render_rect(&mut self, _x: u32, _y: u32, _w: u32, _h: u32, _color: (u8, u8, u8)) {}
        fn begin_row(&mut self) {}
        fn end_row(&mut self) {}
        fn begin_column(&mut self) {}
        fn end_column(&mut self) {}
        fn output(&self) -> &str { "" }
    }

    #[test]
    fn null_renderer_implements_trait() {
        let mut r = NullRenderer;
        r.render_text("hello", (255, 255, 255));
        r.render_rect(0, 0, 100, 50, (0, 0, 0));
        r.begin_row();
        r.end_row();
        r.begin_column();
        r.end_column();
        assert_eq!(r.output(), "");
    }
}
