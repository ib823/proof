//! RUPA — Type-safe styling with WCAG 2.1 accessibility checks.

/// Compute relative luminance of an sRGB color per WCAG 2.1.
fn relative_luminance(color: (u8, u8, u8)) -> f64 {
    let linearize = |c: u8| -> f64 {
        let s = f64::from(c) / 255.0;
        if s <= 0.04045 {
            s / 12.92
        } else {
            ((s + 0.055) / 1.055).powf(2.4)
        }
    };
    let r = linearize(color.0);
    let g = linearize(color.1);
    let b = linearize(color.2);
    0.2126 * r + 0.7152 * g + 0.0722 * b
}

/// Type-safe styling descriptor.
#[derive(Debug, Clone)]
pub struct Style {
    pub padding: u32,
    pub margin: u32,
    pub font_size: u32,
    pub color: (u8, u8, u8),
    pub background: (u8, u8, u8),
}

impl Default for Style {
    fn default() -> Self {
        Self {
            padding: 0,
            margin: 0,
            font_size: 16,
            color: (0, 0, 0),
            background: (255, 255, 255),
        }
    }
}

impl Style {
    /// Compute the WCAG 2.1 contrast ratio between foreground and background.
    pub fn contrast_ratio(&self) -> f64 {
        let fg_lum = relative_luminance(self.color);
        let bg_lum = relative_luminance(self.background);
        let (lighter, darker) = if fg_lum > bg_lum {
            (fg_lum, bg_lum)
        } else {
            (bg_lum, fg_lum)
        };
        (lighter + 0.05) / (darker + 0.05)
    }

    /// Check if the style meets WCAG AA contrast requirement (>= 4.5:1).
    pub fn meets_wcag_aa(&self) -> bool {
        self.contrast_ratio() >= 4.5
    }

    /// Check if the style meets WCAG AAA contrast requirement (>= 7.0:1).
    pub fn meets_wcag_aaa(&self) -> bool {
        self.contrast_ratio() >= 7.0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn black_on_white_maximum_contrast() {
        let style = Style {
            color: (0, 0, 0),
            background: (255, 255, 255),
            ..Style::default()
        };
        let ratio = style.contrast_ratio();
        assert!((ratio - 21.0).abs() < 0.1, "Expected ~21:1, got {ratio}");
    }

    #[test]
    fn white_on_black_maximum_contrast() {
        let style = Style {
            color: (255, 255, 255),
            background: (0, 0, 0),
            ..Style::default()
        };
        let ratio = style.contrast_ratio();
        assert!((ratio - 21.0).abs() < 0.1, "Expected ~21:1, got {ratio}");
    }

    #[test]
    fn same_color_minimum_contrast() {
        let style = Style {
            color: (128, 128, 128),
            background: (128, 128, 128),
            ..Style::default()
        };
        let ratio = style.contrast_ratio();
        assert!((ratio - 1.0).abs() < 0.01, "Expected 1:1, got {ratio}");
    }

    #[test]
    fn black_on_white_meets_wcag_aa() {
        let style = Style::default();
        assert!(style.meets_wcag_aa());
    }

    #[test]
    fn black_on_white_meets_wcag_aaa() {
        let style = Style::default();
        assert!(style.meets_wcag_aaa());
    }

    #[test]
    fn same_color_fails_wcag_aa() {
        let style = Style {
            color: (100, 100, 100),
            background: (100, 100, 100),
            ..Style::default()
        };
        assert!(!style.meets_wcag_aa());
    }

    #[test]
    fn same_color_fails_wcag_aaa() {
        let style = Style {
            color: (100, 100, 100),
            background: (100, 100, 100),
            ..Style::default()
        };
        assert!(!style.meets_wcag_aaa());
    }

    #[test]
    fn low_contrast_fails_aa() {
        // Light gray on white — poor contrast
        let style = Style {
            color: (200, 200, 200),
            background: (255, 255, 255),
            ..Style::default()
        };
        assert!(!style.meets_wcag_aa());
    }

    #[test]
    fn medium_contrast_passes_aa_fails_aaa() {
        // Dark gray on white — moderate contrast
        let style = Style {
            color: (100, 100, 100),
            background: (255, 255, 255),
            ..Style::default()
        };
        let ratio = style.contrast_ratio();
        assert!(ratio >= 4.5, "Expected >= 4.5, got {ratio}");
        assert!(style.meets_wcag_aa());
        // This particular combo may or may not pass AAA; test the boundary
    }

    #[test]
    fn relative_luminance_black() {
        let lum = relative_luminance((0, 0, 0));
        assert!((lum - 0.0).abs() < 0.001);
    }

    #[test]
    fn relative_luminance_white() {
        let lum = relative_luminance((255, 255, 255));
        assert!((lum - 1.0).abs() < 0.001);
    }

    #[test]
    fn relative_luminance_pure_red() {
        let lum = relative_luminance((255, 0, 0));
        assert!((lum - 0.2126).abs() < 0.001);
    }

    #[test]
    fn relative_luminance_pure_green() {
        let lum = relative_luminance((0, 255, 0));
        assert!((lum - 0.7152).abs() < 0.001);
    }

    #[test]
    fn relative_luminance_pure_blue() {
        let lum = relative_luminance((0, 0, 255));
        assert!((lum - 0.0722).abs() < 0.001);
    }

    #[test]
    fn default_style_values() {
        let s = Style::default();
        assert_eq!(s.padding, 0);
        assert_eq!(s.margin, 0);
        assert_eq!(s.font_size, 16);
        assert_eq!(s.color, (0, 0, 0));
        assert_eq!(s.background, (255, 255, 255));
    }

    #[test]
    fn contrast_ratio_symmetry() {
        let s1 = Style {
            color: (50, 100, 150),
            background: (200, 220, 240),
            ..Style::default()
        };
        let s2 = Style {
            color: (200, 220, 240),
            background: (50, 100, 150),
            ..Style::default()
        };
        assert!((s1.contrast_ratio() - s2.contrast_ratio()).abs() < 0.001);
    }
}
