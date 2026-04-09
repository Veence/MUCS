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
    
    func gridCell(comp: any Component, width: CGFloat) -> Path {
        let ratio = comp.symbol.height / comp.symbol.width
        return comp.symbol.path(CGRect(x: 0, y: 0, width: width, height: width * ratio))
        
    }
    
    func snapToGrid(point: CGPoint) -> CGPoint {
        CGPoint(x: round(point.x / s.gridSpacing) * s.gridSpacing, y: round(point.y / s.gridSpacing) * s.gridSpacing)
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
                                    let comp = comps[idx]()
                                    let color: Color = idx == s.selectedIdx ? .accentColor : .secondary
                                    gridCell(comp: comp, width: geom.size.width)
                                        .stroke(color, lineWidth: 2)
                                        .contentShape(Rectangle())
                                        .onTapGesture { s.selectedComp = comp
                                            s.selectedIdx = idx }
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
                    .onContinuousHover { phase in
                        switch phase {
                            case .active(let location): s.mPos = s.snapToGrid ? snapToGrid (point: location) : location
                            case .ended: s.mPos = nil; break
                        }
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

