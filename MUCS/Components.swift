//
//  Component.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//
import SwiftUI

enum ComponentType: CaseIterable {
    case R          // Lumped resistor
    case L          // Lumped inductor
    case C          // Lumped capacitor
    
    case D          // Diode
    case Q          // Bipolar Transistor
    case F          // FET
    
    // Transmission Lines
    case ML        // Microstrip line
    case SL        // Strip line
    case CW        // Coplanar Waveguide
    case TJ        // Tee Junction
    case TC        // Cross Junction
    case MS        // Microstrip short
    case MO        // Microstrip open
    case MT        // Microstrip Taper
    
    // Generic case
    case S2
    case S4        // Generic (S-parameters defined)
    case S6
}

// A struct containing component characteristics
struct Component {
    var type: ComponentType                                   // Component type name
    var name: String
    var ports: Int
    var symbol: Symbol                                        // Draw the symbol
}

// A struct describing the component's symbol
struct Symbol {
    let width: CGFloat
    let height: CGFloat
    let portCoordinates: [CGPoint]
    let path: (Double) -> Path
}

// Component once it is placed on the sheet
struct PlacedComponent: Identifiable {
    let id: String                                                  // ID
    let name: String                                                // Name (R1, C3…)
    let comp: Component                                             // The component itself
    let pos: CGPoint                                                // Its coordinates
    let rot: Double                                                 // Rotation applied
    
    // Get the ports' locations in
    func getAbsolutePins(unit: CGFloat) -> [CGPoint] {
        // We use the symbol width/height to know how far the pins are from center
        let w = comp.symbol.width * unit
        let h = comp.symbol.height * unit
        
        return comp.symbol.portCoordinates.map { pt in
            // 1. Calculate the local unrotated position (scaling from units to pixels)
            let localX = pt.x * w
            let localY = pt.y * h
            
            // 2. Perform coordinate switching (The "Fast" Rotation)
            var rotatedOffset: CGPoint
            
            switch Int(rot) % 360 {
                case 90, -270:
                    // (x, y) -> (-y, x)
                    rotatedOffset = CGPoint(x: -localY, y: localX)
                case 180, -180:
                    // (x, y) -> (-x, -y)
                    rotatedOffset = CGPoint(x: -localX, y: -localY)
                case 270, -90:
                    // (x, y) -> (y, -x)
                    rotatedOffset = CGPoint(x: localY, y: -localX)
                default: // 0 degrees
                    rotatedOffset = CGPoint(x: localX, y: localY)
            }
            
            // 3. Add to the component's position on the sheet
            return CGPoint(
                x: pos.x + rotatedOffset.x,
                y: pos.y + rotatedOffset.y
            )
        }
    }
}
