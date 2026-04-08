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
    
    var backgroundColor: Color = .gray
    
    var useGrid: Bool = true                                    // Display grid?
    var gridColor: Color = Color(white: 0.5)                    // Mid-grey
    var gridSpacing: CGFloat = 20                               // Default grid spacing
    var snapToGrid: Bool = true                                 // Snap to grid for components/wire placement
    var selectedIdx: Int? = nil
    
    var selectedComp: (any Component)?
    var selectedCategory: UUID?
    var selectedCategoryIndex: Int?
    
    var zoom: CGFloat = 1.0
    var offset: CGPoint = .init(x: 0, y: 0)
    var worldSize: CGFloat = 5000
        
    // Positions logiques et physiques
    var mScreenPos: CGPoint? = nil
    var mSpacePos: CGPoint? {
        if let mSP = mScreenPos {
            let x = mSP.x * zoom + offset.x
            let y = mSP.y * zoom + offset.y
            return .init(x: x, y: y)
        }
        return nil
    }
        
    var placedComponents: [PlacedComponent] = []
    
    // Conversion routines from physical to virtual space and vice-versa
    // For CGPoints
    func _toSpace(point: CGPoint) -> CGPoint {
        .init(x: point.x * zoom + offset.x, y: point.y * zoom + offset.y)
    }
    
    func _toScreen(point: CGPoint) -> CGPoint {
        .init(x: (point.x - offset.x) / zoom, y: (point.y - offset.y) / zoom)
    }
    
    // For CGRects
    func _toSpace(rect: CGRect) -> CGRect {
        .init(origin: _toSpace(point: rect.origin), size: rect.size)
    }
    
    func _toScreen(rect: CGRect) -> CGRect {
        .init(origin: _toScreen(point: rect.origin), size: rect.size)
    }
    
    
}
