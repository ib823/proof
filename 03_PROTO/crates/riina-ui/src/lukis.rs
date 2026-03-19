//! LUKIS — Declarative UI evaluation.
//!
//! Provides a simple declarative UI tree that can be evaluated
//! against any `Renderer` backend.

use crate::rupa::Style;
use crate::sinar::Renderer;

/// A declarative UI element.
#[derive(Debug, Clone)]
pub enum Element {
    /// Text content with styling.
    Text(String, Style),
    /// A horizontal row of child elements.
    Row(Vec<Element>),
    /// A vertical column of child elements.
    Column(Vec<Element>),
    /// A styled box containing a child element.
    Box(Style, Box<Element>),
}

/// Evaluate a UI element tree against a renderer.
pub fn evaluate(renderer: &mut dyn Renderer, element: &Element) {
    match element {
        Element::Text(text, style) => {
            renderer.render_text(text, style.color);
        }
        Element::Row(children) => {
            renderer.begin_row();
            for child in children {
                evaluate(renderer, child);
            }
            renderer.end_row();
        }
        Element::Column(children) => {
            renderer.begin_column();
            for child in children {
                evaluate(renderer, child);
            }
            renderer.end_column();
        }
        Element::Box(style, child) => {
            renderer.render_rect(0, 0, 0, 0, style.background);
            evaluate(renderer, child);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::terminal::TerminalRenderer;

    #[test]
    fn evaluate_text_element() {
        let mut r = TerminalRenderer::new();
        let elem = Element::Text("hello".to_string(), Style::default());
        evaluate(&mut r, &elem);
        assert!(r.output().contains("hello"));
    }

    #[test]
    fn evaluate_row_element() {
        let mut r = TerminalRenderer::new();
        let elem = Element::Row(vec![
            Element::Text("a".to_string(), Style::default()),
            Element::Text("b".to_string(), Style::default()),
        ]);
        evaluate(&mut r, &elem);
        let out = r.output();
        assert!(out.contains("a"));
        assert!(out.contains("b"));
    }

    #[test]
    fn evaluate_nested_column_in_row() {
        let mut r = TerminalRenderer::new();
        let elem = Element::Row(vec![
            Element::Column(vec![
                Element::Text("top".to_string(), Style::default()),
                Element::Text("bottom".to_string(), Style::default()),
            ]),
        ]);
        evaluate(&mut r, &elem);
        let out = r.output();
        assert!(out.contains("top"));
        assert!(out.contains("bottom"));
    }
}
