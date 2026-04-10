//
//  ContentView.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @State var s: GUIState
    @FocusState var canvasFocused: Bool
    
    // Display component symbols in the pick area (left)
    func gridCell(comp: Component, width: CGFloat) -> Path {
        return comp.symbol.path(width)
    }
    
    // Act on mouse click    
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List (categories, id: \.id, selection: $s.selectedCategory) {category in
                    Text (category.name)
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .onChange(of: s.selectedCategory) {
                    s.selectedCategoryIndex = categories.firstIndex(where: {$0.id == s.selectedCategory})!
                }
            }
            ,content: {
                if let selectedIndex = s.selectedCategoryIndex {
                    let comps = categories[selectedIndex].components
                    GeometryReader {geom in
                        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(0..<comps.count, id: \.self) {idx in
                                GridRow(alignment: .center) {
                                    let comp = comps[idx]
                                    let color: Color = idx == s.selectedIdx ? .accentColor : .secondary
                                    gridCell(comp: comp, width: 10)
                                        .stroke(color, lineWidth: 2)
                                        .contentShape(Rectangle())
                                        .onTapGesture { s.selectedComp = comp; s.selectedIdx = idx; s.rot = 0 }
                                }
                            }
                        }
                    }
                    .padding(10)
                }
            }
            ,detail: {
                VStack {
                    ZStack(alignment: .topLeading) {
                        Background(s: s)
                        Cursor (s: s)
                        ComponentLayer(s: s)
                    }
                    .focusable()
                    .focused($canvasFocused)
                    .focusEffectDisabled()
                    .overlay {CanvasKeyboardInterceptor(s: s)
                        .allowsHitTesting(true)}
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(let loc):
                            s.mScr = loc
                            let absPos = s._toSheet(loc: loc)
                            
                            // Only show the PIN and snap if on the actual paper
                            if absPos.x >= 0 && absPos.x <= s.sheetSize.width &&
                               absPos.y >= 0 && absPos.y <= s.sheetSize.height {
                                s.mPos = s.snapToGrid ? s.snapPoint(loc: absPos) : absPos
                                if !s.mouseIn {s.mouseIn = true; NSCursor.hide(); canvasFocused = true}
                            } else {
                                s.mPos = nil // Hide crosshair in void
                                s.mouseIn = false
                                canvasFocused = false
                                NSCursor.unhide()
                            }
                        case .ended:
                            s.mouseIn = false
                            NSCursor.unhide()
                        }
                    }
                    .onTapGesture {
                        s.click ()
                    }
                    .onKeyPress(.escape) {s.selectedComp = nil; return .handled}
                    .onKeyPress(KeyEquivalent("r")) {s.rot = (s.rot + s.rotStep) % 360; return .handled}
                    Spacer ()
                    Text ("Mouse: \(s.mPos?.debugDescription ?? "---"), Offset: \((s.offset).debugDescription), Zoom: \(s.zoom)")
                }
            }
        )
    }
    
}


#Preview {
    MainView(s: GUIState())
}

