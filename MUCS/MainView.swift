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
    
    // Display component symbols in the pick area (left)
    func gridCell(comp: Component, width: CGFloat) -> Path {
        return comp.symbol.path(width)
        
    }
    
    
    // Act on mouse click
    func click() {
        // If we have a selected component, place it on the sheet
        if let comp = s.selectedComp, let mP = s.mPos, let rot = s.compRotation {
            let name = comp.name + String (s.getNewIdentifier(forType: comp.type))
            s.placedComponents.append(PlacedComponent(id: UUID().uuidString, name: name, comp: comp, pos: mP, rot: rot))
            print ("Composant \(name), position \(mP.debugDescription)")
        }
    }
    
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
                                        .onTapGesture { s.selectedComp = comp; s.selectedIdx = idx; s.compRotation = .r0 }
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
                    .overlay {CanvasKeyboardInterceptor(s: s)
                        .allowsHitTesting(true)}
                    .onHover {isIn in s.mouseIn = isIn; if isIn {NSCursor.hide ()} else {NSCursor.unhide ()}}
                    .onContinuousHover { phase in
                        switch phase {
                            case .active(let loc):
                                s.mScr = loc
                                let absPos = s._toSheet(loc: loc)
                                s.mPos = s.snapToGrid ? s.snapPoint(loc: absPos) : absPos
                            case .ended: s.mScr = nil; s.mPos = nil; break
                        }
                    }
                    .onTapGesture {
                        click ()
                    }
                    
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

