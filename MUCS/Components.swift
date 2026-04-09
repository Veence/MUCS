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

// For rotating symbols
enum Rotation {
    case r0
    case r90
    case r180
    case r270
}

// Component once it is placed on the sheet
struct PlacedComponent: Identifiable {
    let id: String                                                  // ID
    let name: String                                                // Name (R1, C3…)
    let comp: Component                                             // The component itself
    let pos: CGSize                                                 // Its coordinates
    let rot: Rotation                                               // Rotation applied
}
