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
    
    // Snap mouse coordinates to grid
    func snapToGrid(point: CGPoint) -> CGPoint {
        CGPoint(x: round(point.x / s.gridSpacing) * s.gridSpacing, y: round(point.y / s.gridSpacing) * s.gridSpacing)
    }
    
    // Act on mouse click
    func click() {
        // If we have a selected component, place it on the sheet
        if let comp = s.selectedComp, let mP = s.mPos, let rot = s.compRotation {
            let name = comp.name + String (s.getNewIdentifier(forType: comp.type))
            let pos = CGSize(width: mP.x, height: mP.y)
            s.placedComponents.append(PlacedComponent(id: UUID().uuidString, name: name, comp: comp, pos: pos, rot: rot))
            print ("Composant \(name), position \(pos.debugDescription)")
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
                    ZStack {
                        Background(s: s)
                        ComponentLayer(s: s)
                        // Scroll view to handle the coordinates
                        ScrollView([.horizontal, .vertical]) {
                            Color.clear
                                .frame(width: s.worldSize * s.zoom, height: s.worldSize * s.zoom)
                        }
                        .coordinateSpace(name: CoordinateSpace.named("SheetSpace"))
                        .onScrollGeometryChange(for: CGPoint.self,
                                                of: {geom in
                            let x = geom.contentOffset.x - geom.contentInsets.leading
                            let y = geom.contentOffset.y + geom.contentInsets.top
                            return CGPoint(x: x, y: y)})
                            {_, new in s.offset = new}
                    }
                    .onHover {isIn in s.mouseIn = isIn; if isIn {NSCursor.hide ()} else {NSCursor.unhide ()}}
                    .onContinuousHover { phase in
                        switch phase {
                            case .active(let location): s.mPos = s.snapToGrid ? snapToGrid (point: location) : location
                            case .ended: s.mPos = nil; break
                        }
                    }
                    .onTapGesture {
                        click ()
                    }
                }
                Spacer ()
                Text ("Mouse: \((s.mPos ?? .zero).debugDescription), Offset: \(s.offset.debugDescription), Zoom: \(s.zoom)")
            }
        )
    }
    
}


#Preview {
    MainView(s: GUIState())
}

