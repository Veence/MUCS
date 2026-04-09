//
//  MainViewState.swift
//  MUCS
//
//  Created by Vincent on 10/12/2025.
//

import Foundation
import SwiftUI

// State object for the GUI

@Observable
final class GUIState {
    
    var backgroundColor: Color = .black
    
    var useGrid: Bool = true                                    // Display grid?
    var gridColor: Color = Color(white: 1.0, opacity: 0.5)                    // Mid-grey
    var gridSpacing: CGFloat = 20                               // Default grid spacing
    var snapToGrid: Bool = true                                 // Snap to grid for components/wire placement
    var selectedIdx: Int? = nil
    
    var selectedComp: (any Component)?
    var selectedCategory: UUID?
    var selectedCategoryIndex: Int?
    
    var worldSize: CGFloat = 5000
    var zoom: CGFloat = 1.0
    let possibleZooms = [0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0]

    var scrollPos : ScrollPosition = .init(point: .zero)
    var offset: CGPoint = .zero
    
    var mouseIn: Bool = false
        
    // Positions logiques et physiques
    var mPos: CGPoint? = nil
    
    
    // Zoom
    func zoomIn () {
        zoom = min (zoom * 2.0, 16)
        
    }
    
    func zoomOut () {
        zoom = max (zoom / 2.0, 0.125)
    }
}

// For menu handling

struct GUIStateKey: FocusedValueKey {
    typealias Value = GUIState
}

extension FocusedValues {
    var activeState: GUIState? {
        get { self[GUIStateKey.self] }
        set { self[GUIStateKey.self] = newValue }
    }
}
