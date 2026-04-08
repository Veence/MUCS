//
//  Component.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//
import SwiftUI

// A struct describing the component's symbol
struct Symbol {
    let width: CGFloat
    let height: CGFloat
    let portCoordinates: [CGPoint]
    let path: (CGRect) -> Path
}

// For rotating symbols
enum Rotation {
    case r0
    case r90
    case r180
    case r270
}

struct PlacedComponent: Identifiable {
    let id: ObjectIdentifier                                        // ID
    let name: String                                                // Name (R1, C3…)
    let comp: any Component                                         // The component itself
    let pos: CGPoint                                                // Its coordinates
    let rot: Rotation                                               // Rotation applied
}

// A struct containing component characteristics
protocol Component {
    var type: String {get}                                          // Component type name
    var name: String {get set}                                      // Prefix (R, C, L …)
    var nbOfPorts: Int {get}                                        // Number of ports (2 dipole, etc.)
    
    var symbol: Symbol {get}                                        // Draw the symbol
}

// Resistor drawn as a wiggle
struct ResistorWiggle: @MainActor Component {
    let type: String = "ResistorWiggle"
    var name: String = "Rx"
    let nbOfPorts: Int = 2
    
    // Graphic data
    let symbol = Symbol(
        width: 8.0,
        height: 2.0,
        portCoordinates: [.init(x: -0.5, y: 0), .init(x: 0.5, y: 0)],
        path: {rect in
            
            let w = rect.size.width / 16
            let h = rect.size.height / 2
            
            var path = Path()
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addEllipse(in: CGRect(x: h / 10, y: h - h / 20, width: h / 10, height: h / 10))
            
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addLine(to: CGPoint(x: 2 * w, y: h))
            path.addLine(to: CGPoint(x: 3 * w, y: 2 * h))
            path.addLine(to: CGPoint(x: 5 * w, y: 0))
            path.addLine(to: CGPoint(x: 7 * w, y: 2 * h))
            path.addLine(to: CGPoint(x: 9 * w, y: 0))
            path.addLine(to: CGPoint(x: 11 * w, y: 2 * h))
            path.addLine(to: CGPoint(x: 13 * w, y: 0))
            path.addLine(to: CGPoint(x: 14 * w, y: h))
            path.addLine(to: CGPoint(x: 16 * w, y: h))
            path.move(to: CGPoint(x: 16 * w - h / 10, y: h - h / 20))
            
            path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: h - h / 20, width: h / 10, height: h / 10))
            
            return path
        }
    )
}


// Resistor drawn as a box
struct ResistorBox: @MainActor Component {
    let type: String = "ResistorBox"
    var name: String = "Rx"
    var nbOfPorts: Int = 2
    
    // Draw the wiggle
    let symbol = Symbol (
        width: 8.0,
        height: 2.0,
        portCoordinates: [.init(x: -0.5, y: 0), .init(x: 0.5, y: 0)],
        path: {rect in
            
            let w = rect.size.width / 16
            let h = rect.size.height / 2
            
            var path = Path()
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addEllipse(in: CGRect(x: h / 10, y: 19 * h / 20, width: h / 10, height: h / 10))
            
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addLine(to: CGPoint(x: 2 * w, y: h))
            path.addRect(CGRect(x: 2 * w, y: 0, width: 12 * w, height: 2 * h))
            path.move(to: CGPoint(x: 14 * w, y: h))
            path.addLine(to: CGPoint(x: 16 * w, y: h))
            
            path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: 19 * h / 20, width: h / 10, height: h / 10))
            return path
        }
    )
}
