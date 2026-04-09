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
    var gridColor: Color = Color(white: 1.0, opacity: 0.5)      // Mid-grey
    var gridSpacing: CGFloat = 20                               // Default grid spacing
    var snapToGrid: Bool = true                                 // Snap to grid for components/wire placement
    
    var worldSize: CGFloat = 5000                               // Default sheet size
    let possibleZooms = [0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0]
    var zoomIndex: Int = 3                                      // Default zoom is 1
    var zoom: Double {possibleZooms [zoomIndex]}

    var scrollPos : ScrollPosition = .init(point: .zero)
    var offset: CGPoint = .zero
    
    var mouseIn: Bool = false
        
    // Positions logiques et physiques
    var mPos: CGPoint? = nil
    var mOff: CGSize {.init(width: mPos?.x ?? 0, height: mPos?.y ?? 0)}
    var selectedIdx: Int? = nil
    
    var selectedComp: Component?
    var selectedCategory: UUID?
    var selectedCategoryIndex: Int?
    var compRotation: Rotation?
    
    var IDdict: [ComponentType:Int] = Dictionary(uniqueKeysWithValues: ComponentType.allCases.map {($0, 0)})
    var placedComponents: [PlacedComponent] = []
    
    // Zoom
    
    func resetZoom () {
        zoomIndex = 3
    }
    
    // Get a new name identifier
    func getNewIdentifier(forType type: ComponentType) -> Int {
        if let id = IDdict [type] {
            IDdict [type] = id + 1
            return id
        }
        fatalError("Inconsistency in \(#function). Unknown component type.")
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
