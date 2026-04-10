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
    
    var viewportSize: CGSize = .zero                            // Window dimensions
    var backgroundColor: Color = .black                         // Window background colour
    
    var useGrid: Bool = true                                    // Display grid?
    var gridColor: Color = Color(white: 1.0, opacity: 0.5)      // Mid-grey
    var gridSpacing: CGFloat = 20                               // Default grid spacing
    var screenGrid: CGFloat {gridSpacing * zoom}
    var snapToGrid: Bool = true                                 // Snap to grid for components/wire placement
    
    var sheetSize = CGSize(width: 4000, height: 2000)           // Default sheet size
    let possibleZooms = [0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 50.0, 100.0]
    var zoomIndex: Int = 3                                      // Default zoom is 1
    var zoom: Double {possibleZooms [zoomIndex]}

    var scrollDisabled: Bool = false                            // If screen space is greater than sheet size
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
    var rot = 0
    var rotStep = 90
    
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
    // 2. Refined Zoom Logic
    func recomputeOffsetAfterZoom(oldZ: Double, newZ: Double) {
        // Determine the Anchor Point in Screen Space
        // If mouse is in, use screen mouse pos. If not, use window center.
        let anchorBtn: CGPoint
        if let mP = mScr, mouseIn {
            anchorBtn = mP
        } else {
            anchorBtn = CGPoint(x: viewportSize.width / 2, y: viewportSize.height / 2)
        }
        
        // Convert Screen Anchor to Sheet Space (using the OLD zoom/offset)
        let worldAnchor = CGPoint(
            x: (anchorBtn.x + offset.x) / oldZ,
            y: (anchorBtn.y + offset.y) / oldZ
        )
        
        // Calculate the New Offset
        // This formula ensures worldAnchor stays at the same anchorBtn screen coordinate
        let newOffX = worldAnchor.x * newZ - anchorBtn.x
        let newOffY = worldAnchor.y * newZ - anchorBtn.y
        
        self.offset = CGPoint(x: newOffX, y: newOffY)
        
        // IMPORTANT: Apply clamping immediately so we don't end up in the void
        clampOffset()
    }

    func clampOffset() {
        let worldW = sheetSize.width * zoom
        let worldH = sheetSize.height * zoom
        
        // Horizontal Clamping
        if worldW <= viewportSize.width {
            // Center the sheet if it's smaller than the window
            offset.x = (worldW - viewportSize.width) / 2
        } else {
            let maxOffX = worldW - viewportSize.width
            offset.x = min(max(0, offset.x), maxOffX)
        }
        
        // Vertical Clamping
        if worldH <= viewportSize.height {
            offset.y = (worldH - viewportSize.height) / 2
        } else {
            let maxOffY = worldH - viewportSize.height
            offset.y = min(max(0, offset.y), maxOffY)
        }
    }
    
    // Increase zoom
    func adjustZoom(delta: Int) {
        let oldZoom = zoom
        
        // Step zoomIndex based on wheel direction
        if delta == 1 {zoomIndex = min(zoomIndex + 1, possibleZooms.count - 1)}
        if delta == 0 {zoomIndex = 3}
        if delta == -1 {zoomIndex = max(0, zoomIndex - 1)}
    
        let newZoom = zoom
        
        // Choose an anchor point in Screen Space
        // If mouse is "out", use the center of the window
        let anchorBtn: CGPoint
        if mouseIn {
            anchorBtn = mOff
        } else {
            anchorBtn = CGPoint(x: viewportSize.width / 2, y: viewportSize.height / 2)
        }
        
        // World coordinate of that anchor BEFORE zoom
        let worldAnchor = CGPoint(
            x: (anchorBtn.x + offset.x) / oldZoom,
            y: (anchorBtn.y + offset.y) / oldZoom
        )
        
        // Update offset to keep worldAnchor under anchorBtn at newZoom
        self.offset.x = worldAnchor.x * newZoom - anchorBtn.x
        self.offset.y = worldAnchor.y * newZoom - anchorBtn.y
        
        clampOffset()
    }
    
    // Get a new name identifier
    func getNewIdentifier(forType type: ComponentType) -> Int {
        if let id = IDdict [type] {
            IDdict [type] = id + 1
            return id
        }
        fatalError("Inconsistency in \(#function). Unknown component type.")
    }
    
    // Handle mouse click event (or equivalent)
    func click() {
        // If we have a selected component, place it on the sheet
        if let comp = selectedComp, let mP = mPos {
            let name = comp.name + String (getNewIdentifier(forType: comp.type))
            placedComponents.append(PlacedComponent(id: UUID().uuidString, name: name, comp: comp, pos: mP, rot: Double (rot)))
        }
    }

    // Handle key event
    

}
