//
//  WheelOverlay.swift
//  MUCS
//
//  Created by Vincent on 09/04/2026.
//

import Foundation
import SwiftUI

struct CanvasKeyboardInterceptor: NSViewRepresentable {
    @Bindable var s: GUIState
    
    func makeNSView(context: Context) -> NSView {
        let view = InteractionView()
        view.s = s
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Keeps the reference updated if s changes
        (nsView as? InteractionView)?.s = s
    }
    
    class InteractionView: NSView {
        var s: GUIState?
        
        // Allow this view to receive all types of mouse/scroll events
        override var acceptsFirstResponder: Bool { true }
        
        override func scrollWheel(with event: NSEvent) {
            guard let s else { return }
            
            // Update scroll
            let newOffsetX = s.offset.x + event.scrollingDeltaX
            let newOffsetY = s.offset.y + event.scrollingDeltaY
            
            // Compute the max. possible offset given the window size
            let maxOffX = s.sheetSize.width * s.zoom - self.bounds.width
            let maxOffY = s.sheetSize.height * s.zoom - self.bounds.height
            
            // Clamping
            let newOffX = min(max(0, newOffsetX), maxOffX)
            let newOffY = min(max(0, newOffsetY), maxOffY)
            
            s.offset = .init(x: newOffX, y: newOffY)
            
            // Update mouse world coordinates to match the new clamped position
            if let mP = s.mScr {
                s.mPos = s.snapPoint(loc: s._toSheet(loc: mP))
            }
        }
    }
}

