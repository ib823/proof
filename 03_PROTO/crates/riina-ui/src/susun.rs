//! SUSUN — Layout engine.
//!
//! Provides simple row/column layout computation with overlap detection.

/// A positioned box in the layout.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct LayoutBox {
    pub x: u32,
    pub y: u32,
    pub width: u32,
    pub height: u32,
}

/// Lay out children in a horizontal row within a container.
/// Children are placed left-to-right starting at x=0, y=0.
pub fn layout_row(children: &[LayoutBox], _container_width: u32) -> Vec<LayoutBox> {
    let mut result = Vec::with_capacity(children.len());
    let mut x_offset = 0u32;
    for child in children {
        result.push(LayoutBox {
            x: x_offset,
            y: 0,
            width: child.width,
            height: child.height,
        });
        x_offset = x_offset.saturating_add(child.width);
    }
    result
}

/// Lay out children in a vertical column within a container.
/// Children are placed top-to-bottom starting at x=0, y=0.
pub fn layout_column(children: &[LayoutBox], _container_height: u32) -> Vec<LayoutBox> {
    let mut result = Vec::with_capacity(children.len());
    let mut y_offset = 0u32;
    for child in children {
        result.push(LayoutBox {
            x: 0,
            y: y_offset,
            width: child.width,
            height: child.height,
        });
        y_offset = y_offset.saturating_add(child.height);
    }
    result
}

/// Check that no two layout boxes overlap.
pub fn no_overlap(boxes: &[LayoutBox]) -> bool {
    for i in 0..boxes.len() {
        for j in (i + 1)..boxes.len() {
            let a = &boxes[i];
            let b = &boxes[j];
            // Two rects overlap if they intersect on both axes
            let x_overlap = a.x < b.x + b.width && b.x < a.x + a.width;
            let y_overlap = a.y < b.y + b.height && b.y < a.y + a.height;
            if x_overlap && y_overlap {
                return false;
            }
        }
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_box(w: u32, h: u32) -> LayoutBox {
        LayoutBox { x: 0, y: 0, width: w, height: h }
    }

    #[test]
    fn row_layout_positions() {
        let children = vec![make_box(100, 50), make_box(200, 50), make_box(150, 50)];
        let laid_out = layout_row(&children, 800);
        assert_eq!(laid_out[0].x, 0);
        assert_eq!(laid_out[1].x, 100);
        assert_eq!(laid_out[2].x, 300);
    }

    #[test]
    fn row_layout_preserves_dimensions() {
        let children = vec![make_box(100, 50), make_box(200, 75)];
        let laid_out = layout_row(&children, 800);
        assert_eq!(laid_out[0].width, 100);
        assert_eq!(laid_out[0].height, 50);
        assert_eq!(laid_out[1].width, 200);
        assert_eq!(laid_out[1].height, 75);
    }

    #[test]
    fn column_layout_positions() {
        let children = vec![make_box(100, 50), make_box(100, 75), make_box(100, 25)];
        let laid_out = layout_column(&children, 600);
        assert_eq!(laid_out[0].y, 0);
        assert_eq!(laid_out[1].y, 50);
        assert_eq!(laid_out[2].y, 125);
    }

    #[test]
    fn column_layout_preserves_dimensions() {
        let children = vec![make_box(100, 50), make_box(200, 75)];
        let laid_out = layout_column(&children, 600);
        assert_eq!(laid_out[0].width, 100);
        assert_eq!(laid_out[1].width, 200);
    }

    #[test]
    fn row_no_overlap() {
        let children = vec![make_box(100, 50), make_box(100, 50), make_box(100, 50)];
        let laid_out = layout_row(&children, 800);
        assert!(no_overlap(&laid_out));
    }

    #[test]
    fn column_no_overlap() {
        let children = vec![make_box(100, 50), make_box(100, 50), make_box(100, 50)];
        let laid_out = layout_column(&children, 600);
        assert!(no_overlap(&laid_out));
    }

    #[test]
    fn overlapping_boxes_detected() {
        let boxes = vec![
            LayoutBox { x: 0, y: 0, width: 100, height: 100 },
            LayoutBox { x: 50, y: 50, width: 100, height: 100 },
        ];
        assert!(!no_overlap(&boxes));
    }

    #[test]
    fn adjacent_boxes_no_overlap() {
        let boxes = vec![
            LayoutBox { x: 0, y: 0, width: 100, height: 100 },
            LayoutBox { x: 100, y: 0, width: 100, height: 100 },
        ];
        assert!(no_overlap(&boxes));
    }

    #[test]
    fn empty_layout_no_overlap() {
        assert!(no_overlap(&[]));
    }

    #[test]
    fn single_box_no_overlap() {
        let boxes = vec![LayoutBox { x: 0, y: 0, width: 100, height: 100 }];
        assert!(no_overlap(&boxes));
    }

    #[test]
    fn empty_row_layout() {
        let laid_out = layout_row(&[], 800);
        assert!(laid_out.is_empty());
    }

    #[test]
    fn empty_column_layout() {
        let laid_out = layout_column(&[], 600);
        assert!(laid_out.is_empty());
    }
}
