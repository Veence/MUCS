//
//  Component.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//
import SwiftUI

// A struct containing components definitions

protocol Component {
    var type: String {get}                                                            // Component type name
    var id: String {get set}                                                          // Id, ex.: R45
    var parameters: [String: (Double, String, Bool)] {get set}                        // Parameters for the model
    var nbOfPorts: Int {get}                                                          // Number of ports (2 dipole, etc.)
    
    var graphicSymbol: () -> any View {get}
    var nbOfConn: Int {get}
    var connCoord: [(CGFloat, CGFloat)] {get}
}
