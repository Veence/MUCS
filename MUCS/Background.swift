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
            // Don't draw small grids
            if s.screenGrid < 10 {return}
            
            for x in stride(from: s.gridSpacing, to: s.sheetSize.width, by: s.gridSpacing) {
                for y in stride(from: s.gridSpacing, to: s.sheetSize.height, by: s.gridSpacing) {
                    let dot: CGPoint = s._toScreen(loc: CGPoint(x: x, y: y))
                    if dot.x > 0 && dot.y > 0 && dot.x < size.width && dot.y < size.height {
                        // Draw only the visible points of the grid
                        ctx.stroke(Path(CGRect(origin: dot, size: CGSize(width: 1, height: 1))),
                                   with: .color(s.gridColor))
                    }
                }
            }
            
            let sCorner: CGPoint = s._toScreen(loc: .zero)
            let eCorner: CGPoint = s._toScreen(size: s.sheetSize)
            
            var p = Path ()
            p.move(to: sCorner)
            p.addLine(to: CGPoint(x: eCorner.x, y: sCorner.y))
            p.addLine(to: eCorner)
            p.addLine(to: CGPoint(x: sCorner.x,y: eCorner.y))
            p.addLine(to: sCorner)
            ctx.stroke(p, with: .color(Color.red))
        }
        )
        .background(s.backgroundColor)
    }
}
