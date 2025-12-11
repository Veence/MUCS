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
    
    var selectedComp: (any Component)?
    var selectedCategory: UUID?
    var selectedCategoryIndex: Int?
    
    var mouseInCanvas: Bool = false
}
