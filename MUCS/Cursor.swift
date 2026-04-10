//
//  Cursor.swift
//  MUCS
//
//  Created by Vincent on 07/04/2026.
//

import Foundation
import SwiftUI

enum CursorShape {
    case HairPin
    case CrossWires
}


struct Cursor: View {
    
    let s: GUIState
    
    func hairPin () -> Path {
        var p = Path ()
        let size = s.screenGrid
        p.move(to: CGPoint (x: 0, y: -size / 2))
        p.addLine(to: CGPoint(x: 0, y: size / 2))
        p.move(to: CGPoint (x: -size / 2, y: 0))
        p.addLine(to: CGPoint(x: size / 2, y: 0))
        return p
    }

    
    var body: some View {
        if s.mouseIn && s.selectedComp == nil {
            switch s.cursorShape {
                case .HairPin:
                    
                    hairPin().stroke(.white, lineWidth: 1.0).offset(s._toScreen(loc: s.mPos ?? .zero))
                    
                case .CrossWires:
                    Ellipse().stroke(.white, lineWidth: 1.0)
            }
        }
    }
}
