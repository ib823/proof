//! HTML renderer — generates HTML/CSS output.

use crate::sinar::Renderer;

/// A renderer that outputs HTML with inline CSS styling.
pub struct HtmlRenderer {
    output: String,
}

impl HtmlRenderer {
    pub fn new() -> Self {
        Self { output: String::new() }
    }
}

impl Default for HtmlRenderer {
    fn default() -> Self {
        Self::new()
    }
}

impl Renderer for HtmlRenderer {
    fn render_text(&mut self, text: &str, color: (u8, u8, u8)) {
        self.output.push_str(&format!(
            "<span style=\"color:rgb({},{},{})\">{}",
            color.0, color.1, color.2, text
        ));
        self.output.push_str("</span>");
    }

    fn render_rect(&mut self, x: u32, y: u32, w: u32, h: u32, color: (u8, u8, u8)) {
        self.output.push_str(&format!(
            "<div style=\"position:absolute;left:{x}px;top:{y}px;width:{w}px;height:{h}px;background:rgb({},{},{})\">"
            , color.0, color.1, color.2
        ));
        self.output.push_str("</div>");
    }

    fn begin_row(&mut self) {
        self.output.push_str("<div style=\"display:flex;flex-direction:row\">");
    }

    fn end_row(&mut self) {
        self.output.push_str("</div>");
    }

    fn begin_column(&mut self) {
        self.output.push_str("<div style=\"display:flex;flex-direction:column\">");
    }

    fn end_column(&mut self) {
        self.output.push_str("</div>");
    }

    fn output(&self) -> &str {
        &self.output
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn html_text_span() {
        let mut r = HtmlRenderer::new();
        r.render_text("hello", (255, 0, 0));
        let out = r.output();
        assert!(out.contains("<span"));
        assert!(out.contains("color:rgb(255,0,0)"));
        assert!(out.contains("hello"));
        assert!(out.contains("</span>"));
    }

    #[test]
    fn html_rect_div() {
        let mut r = HtmlRenderer::new();
        r.render_rect(10, 20, 100, 50, (0, 128, 255));
        let out = r.output();
        assert!(out.contains("<div"));
        assert!(out.contains("left:10px"));
        assert!(out.contains("top:20px"));
        assert!(out.contains("width:100px"));
        assert!(out.contains("height:50px"));
        assert!(out.contains("background:rgb(0,128,255)"));
        assert!(out.contains("</div>"));
    }

    #[test]
    fn html_row_flexbox() {
        let mut r = HtmlRenderer::new();
        r.begin_row();
        r.end_row();
        let out = r.output();
        assert!(out.contains("flex-direction:row"));
    }

    #[test]
    fn html_column_flexbox() {
        let mut r = HtmlRenderer::new();
        r.begin_column();
        r.end_column();
        let out = r.output();
        assert!(out.contains("flex-direction:column"));
    }

    #[test]
    fn html_default() {
        let r = HtmlRenderer::default();
        assert_eq!(r.output(), "");
    }
}
