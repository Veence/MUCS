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
        GeometryReader { proxy in
            Canvas(renderer: {ctx, size in
                // Compute the virtual space corresponding to the current window
                let window = s._toSpace(rect: CGRect(origin: .zero, size: size))
                let startX = (window.origin.x / s.gridSpacing) * s.gridSpacing
                let startY = (window.origin.y / s.gridSpacing) * s.gridSpacing
                for x in stride(from: startX, to: window.width, by: s.gridSpacing) {
                    for y in stride(from: startY, to: window.height, by: s.gridSpacing) {
                        let point = s._toScreen(point: CGPoint(x: x, y: y))
                        ctx.stroke(Path(ellipseIn: .init(origin: point, size: .init(width: 1, height: 1))), with: .color(s.gridColor))
                    }
                }
            }
            )
        }
    }
}
