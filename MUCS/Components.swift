//
//  Component.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//
import SwiftUI

// A struct containing components definitions

protocol Component: Identifiable {
    var type: String {get}                                          // Component type name
    var id: String {get}                                            // UUID
    var name: String {get set}                                      // Displayed name
    var nbOfPorts: Int {get}                                        // Number of ports (2 dipole, etc.)
    
    var graphicSymbol: () -> Canvas<EmptyView> {get}                // Draw the symbol
    var ratio: Double {get}                                         // w/h ratio for the symbol
    
    var nbOfConn: Int {get}
    var coord: (CGFloat, CGFloat) {get set}
    var connCoord: [(CGFloat, CGFloat)] {get}
}

// Resistor drawn as a wiggle

struct ResistorWiggle: @MainActor Component {
    let type: String = "Resistor"
    let id: String = UUID().uuidString
    var name: String = "Rx"
    var nbOfPorts: Int = 2
    
    // Draw the wiggle
    let graphicSymbol: () -> Canvas = {
        return Canvas {ctxt, size in
            
            let H = min (size.width / 4, size.height)
            
            let w = size.width / 16
            let h = H / 2
            
            var path = Path()
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addEllipse(in: CGRect(x: h / 10, y: h - h / 20, width: h / 10, height: h / 10))
            ctxt.fill(path, with: .foreground)
            
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
            
            ctxt.stroke(path, with: .foreground)
            
            path = Path ()
            path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: h - h / 20, width: h / 10, height: h / 10))
            ctxt.fill(path, with: .foreground)
            
        }
    }
    let ratio = 2.0
    
    let nbOfConn: Int = 2
    var coord: (CGFloat, CGFloat) = (0, 0)
    let connCoord: [(CGFloat, CGFloat)] = [(0.5, 0), (0.5, 1)]
    
}

// Resistor drawn as a box

struct ResistorBox: @MainActor Component {
    let type: String = "Resistor"
    var id: String = UUID().uuidString
    var name: String = "Rx"
    var parameters: [String: (Double, String, Bool)] = [:]
    var nbOfPorts: Int = 2
    
    // Draw the wiggle
    let graphicSymbol: () -> Canvas = {
        return Canvas {ctxt, size in
            
            let H = min (size.width / 4, size.height)
            
            let w = size.width / 16
            let h = H / 2
            
            var path = Path()
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addEllipse(in: CGRect(x: h / 10, y: 19 * h / 20, width: h / 10, height: h / 10))
            ctxt.fill(path, with: .foreground)
            
            path = Path ()
            path.move(to: CGPoint(x: h / 10, y: h))
            path.addLine(to: CGPoint(x: 2 * w, y: h))
            path.addRect(CGRect(x: 2 * w, y: 0, width: 12 * w, height: 2 * h))
            path.move(to: CGPoint(x: 14 * w, y: h))
            path.addLine(to: CGPoint(x: 16 * w, y: h))
            ctxt.stroke(path, with: .foreground)
            
            path = Path ()
            path.addEllipse(in: CGRect(x: 16 * w - h / 10, y: 19 * h / 20, width: h / 10, height: h / 10))
            ctxt.fill(path, with: .foreground)
        }
    }
    let ratio = 2.0
    
    let nbOfConn: Int = 2
    var coord: (CGFloat, CGFloat) = (0, 0)
    let connCoord: [(CGFloat, CGFloat)] = [(0.5, 0), (0.5, 1)]
}
