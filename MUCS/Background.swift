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
            for x in stride(from: s.gridSpacing - s.offset.x, to: size.width, by: s.gridSpacing) {
                for y in stride(from: s.gridSpacing - s.offset.y, to: size.height, by: s.gridSpacing) {
                    ctx.stroke(Path(CGRect(x: x * s.zoom, y: y * s.zoom, width: 1, height: 1)),
                               with: .color(s.gridColor))
                }
            }
        }
        )
        .background(s.backgroundColor)
    }
}
