//
//  Background.swift
//  MUCS
//
//  Created by Vincent on 06/04/2026.
//

import Foundation
import SwiftUI

// Background with grid
struct Background: View {
    let s: GUIState
    
    var body: some View {
        Canvas(renderer: {ctx, size in
            // 1. Don't draw if zoomed out too far
            if s.screenGrid >= 10 {
                
                // 2. Calculate the "Visible World" bounds
                // We find the first and last grid line index that could possibly be on screen
                
                // Horizontal range
                let firstGridX = max(s.gridSpacing, floor(s.offset.x / s.zoom / s.gridSpacing) * s.gridSpacing)
                let lastGridX = min(s.sheetSize.width, ceil((s.offset.x + size.width) / s.zoom / s.gridSpacing) * s.gridSpacing)
                
                // Vertical range
                let firstGridY = max(s.gridSpacing, floor(s.offset.y / s.zoom / s.gridSpacing) * s.gridSpacing)
                let lastGridY = min(s.sheetSize.height, ceil((s.offset.y + size.height) / s.zoom / s.gridSpacing) * s.gridSpacing)
                
                // 3. Optimized Strides
                for x in stride(from: firstGridX, through: lastGridX, by: s.gridSpacing) {
                    for y in stride(from: firstGridY, through: lastGridY, by: s.gridSpacing) {
                        
                        let dot: CGPoint = s._toScreen(loc: CGPoint(x: x, y: y))
                        
                        // Small safety check (the math above handles most of this)
                        if dot.x >= 0 && dot.y >= 0 && dot.x <= size.width && dot.y <= size.height {
                            ctx.stroke(Path(CGRect(origin: dot, size: CGSize(width: 1, height: 1))),
                                       with: .color(s.gridColor))
                        }
                    }
                }
            }
            
            // --- Sheet Border Drawing ---
            let sCorner: CGPoint = s._toScreen(loc: .zero)
            let eCorner: CGPoint = s._toScreen(size: s.sheetSize)
            
            var p = Path()
            p.addRect(CGRect(origin: sCorner, size: CGSize(width: eCorner.x - sCorner.x, height: eCorner.y - sCorner.y)))
            ctx.stroke(p, with: .color(.red), lineWidth: 1)
        })
    }
}
