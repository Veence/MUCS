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
    var screenGrid: CGFloat {gridSpacing * zoom}
    var snapToGrid: Bool = true                                 // Snap to grid for components/wire placement
    
    var sheetSize = CGSize(width: 4000, height: 2000)           // Default sheet size
    let possibleZooms = [0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0]
    var zoomIndex: Int = 3                                      // Default zoom is 1
    var zoom: Double {possibleZooms [zoomIndex]}

    var scrollPos : ScrollPosition = .init(point: .zero)
    var offset: CGPoint = .zero
    
    var mouseIn: Bool = false
    var cursorShape: CursorShape = .HairPin
        
    // Positions logiques et physiques
    var mScr: CGPoint? = nil            // Mouse screen position (physical)
    var mPos: CGPoint? = nil            // Mouse sheet position (virtual)
    var mOff: CGPoint {mPos ?? .zero}
    var selectedIdx: Int? = nil
    
    // Managing component placement
    var selectedComp: Component?
    var selectedCategory: UUID?
    var selectedCategoryIndex: Int?
    var compRotation: Rotation?
    
    var IDdict: [ComponentType:Int] = Dictionary(uniqueKeysWithValues: ComponentType.allCases.map {($0, 0)})
    var placedComponents: [PlacedComponent] = []
        
    // Transform screen space to sheet space
    func _toSheet(loc: CGPoint) -> CGPoint {
        return CGPoint (x: (loc.x + offset.x) / zoom, y: (loc.y + offset.y) / zoom)
    }
    
    func _toSheet(size: CGSize) -> CGPoint {
        return CGPoint (x: (size.width + offset.x) / zoom, y: (size.height + offset.y) / zoom)
    }
    
    func _toScreen(loc: CGPoint) -> CGPoint {
        return CGPoint(x: loc.x * zoom - offset.x, y: loc.y * zoom - offset.y)
    }
    
    func _toScreen(size: CGSize) -> CGPoint {
        return CGPoint(x: size.width * zoom - offset.x, y: size.height * zoom - offset.y)
    }
    
    func _toScreen(loc: CGPoint) -> CGSize {
        return CGSize(width: loc.x * zoom - offset.x, height: loc.y * zoom - offset.y)
    }
    
    func _toScreen(size: CGSize) -> CGSize {
        return CGSize(width: size.width * zoom - offset.x, height: size.height * zoom - offset.y)
    }
    
    // Snap mouse coordinates to grid
    func snapPoint(loc: CGPoint) -> CGPoint {
        CGPoint(x: round(loc.x / gridSpacing) * gridSpacing, y: round(loc.y / gridSpacing) * gridSpacing)
    }
    
    // Recompute offset after zooming in/out
    func recomputeOffsetAfterZoom (oldZ: Double, newZ: Double) {
        offset = .init(
            x: ((newZ - oldZ) * mOff.x + newZ * offset.x) / oldZ,
            y: ((newZ - oldZ) * mOff.y + newZ * offset.y) / oldZ)
    }
    
    // Increase zoom
    func zoomIn () {
        let oldZoom = zoom
        zoomIndex = min (zoomIndex + 1, possibleZooms.count - 1)
        recomputeOffsetAfterZoom(oldZ: oldZoom, newZ: zoom)
    }
    
    // Decrease zoom
    func zoomOut () {
        let oldZoom = zoom
        zoomIndex = max (0, zoomIndex - 1)
        recomputeOffsetAfterZoom(oldZ: oldZoom, newZ: zoom)
    }
    
    // Reset zoom
    func resetZoom () {
        let oldZoom = zoom
        zoomIndex = 3
        recomputeOffsetAfterZoom(oldZ: oldZoom, newZ: 1)
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
