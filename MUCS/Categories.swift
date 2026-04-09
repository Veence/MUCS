//
//  Categories.swift
//  MUCS
//
//  Created by Vincent on 07/12/2025.
//

import Foundation
import SwiftUI

struct Category: Identifiable {
    let id: UUID = UUID()
    let name: String
    let components: [Component]
}

// Dictionary of components

let categories: [Category] = [
    .init(name:"Lumped", components: [
        // Resistor Wriggle
        Component (
            type: .R,
            name: "R",
            ports: 2,
            symbol: Symbol(
                width: 8.0,
                height: 2.0,
                portCoordinates: [.init(x: -0.5, y: 0), .init(x: 0.5, y: 0)],
                path: {unit in
                    
                    let w = 6 * unit / 16
                    let h = unit
                    
                    var path = Path()
                    path.addEllipse(in: CGRect(x: h / 10, y: -h / 20, width: h / 10, height: h / 10))
                    
                    path.move(to: CGPoint(x: h / 10, y: 0))
                    path.addLine(to: CGPoint(x: 2 * w, y: 0))
                    path.addLine(to: CGPoint(x: 3 * w, y: h))
                    path.addLine(to: CGPoint(x: 5 * w, y: -h))
                    path.addLine(to: CGPoint(x: 7 * w, y: h))
                    path.addLine(to: CGPoint(x: 9 * w, y: -h))
                    path.addLine(to: CGPoint(x: 11 * w, y: h))
                    path.addLine(to: CGPoint(x: 13 * w, y: -h))
                    path.addLine(to: CGPoint(x: 14 * w, y: 0))
                    path.addLine(to: CGPoint(x: 16 * w, y: 0))
                    
                    path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: -h / 20, width: h / 10, height: h / 10))
                    
                    return path
                }
            )
        ),
        // Resistor Box
        Component (
            type: .R,
            name: "R",
            ports: 2,
            
            // Draw the wiggle
            symbol: Symbol (
                width: 8.0,
                height: 2.0,
                portCoordinates: [.init(x: -0.5, y: 0), .init(x: 0.5, y: 0)],
                path: {unit in
                    
                    let w = 6 * unit / 16
                    let h = unit
                    
                    var path = Path()
                    
                    path.addEllipse(in: CGRect(x: h / 10, y: -h / 20, width: h / 10, height: h / 10))
                    
                    path.move(to: CGPoint(x: h / 10, y: 0))
                    path.addLine(to: CGPoint(x: 2 * w, y: 0))
                    path.addRect(CGRect(x: 2 * w, y: -h, width: 12 * w, height: 2 * h))
                    path.move(to: CGPoint(x: 14 * w, y: 0))
                    path.addLine(to: CGPoint(x: 16 * w, y: 0))
                    
                    path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: -h / 20, width: h / 10, height: h / 10))
                    return path
                }
            )
        )
    ])
]

