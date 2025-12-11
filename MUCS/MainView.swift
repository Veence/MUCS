//
//  ContentView.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var s: GUIState
    
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
                    GeometryReader {geom in
                        VStack(alignment: .center) {
                            let comps = categories[selectedIndex].components
                            Grid(alignment: .top) {
                                ForEach(0..<comps.count, id: \.self) {idx in
                                    if idx.isMultiple(of: 2) {
                                        GridRow {
                                            let w = geom.size.width / 3
                                            let r = comps[idx]().ratio
                                            comps[idx]().graphicSymbol()
                                                .frame(width: w, height: w / r)
                                                .onTapGesture { s.selectedComp = comps[idx]() }
                                            if idx + 1 < comps.count {
                                                Spacer ()
                                                let r = comps[idx + 1]().ratio
                                                comps[idx + 1]().graphicSymbol()
                                                    .frame(width: w, height: w / r)
                                                    .onTapGesture { s.selectedComp = comps[idx + 1]() }
                                            } else {
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(10)
                        }
                        Spacer ()
                        
                    }
                }
            }
            ,detail: {
                GeometryReader { geom in
                    ZStack {
                        Canvas(opaque: true, colorMode: .linear) {ctx, size in
                            ctx.fill(Path(CGRect(x: 0, y: 0, width: size.width, height: size.height)), with: .color(s.backgroundColor))}
                        .onHover {isIn in s.mouseInCanvas = isIn}
                        .onChange(of: s.mouseInCanvas) {s.backgroundColor = s.mouseInCanvas ? .blue : .gray}
                        
                        if let sComp = s.selectedComp {
                            sComp.graphicSymbol().position(CGPoint(x: 0, y: 0))
                                .frame(width: 400, height: 200)
                        }
                    }
                }
            }
        )
    }
}

#Preview {
    ContentView(s: .init())
}
