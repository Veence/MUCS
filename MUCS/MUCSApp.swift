//
//  MUCSApp.swift
//  MUCS
//
//  Created by Vincent on 05/12/2025.
//

import SwiftUI
import SwiftData

@main
struct MUCSApp: App {
    
    @State private var s = GUIState ()

    var body: some Scene {
        WindowGroup {
            MainView(s: s)
        }
        .commands {
                    // This adds a new section to the native macOS menus
                    CommandMenu("View") {
                        Button("Zoom In") {
                            s.adjustZoom(delta: 1)
                        }
                        .keyboardShortcut("+", modifiers: .command)
                        

                        Button("Zoom Out") {
                            s.adjustZoom(delta: -1)
                        }
                        .keyboardShortcut("-", modifiers: .command)
                        
                        Divider()
                        
                        Button("Reset Zoom") {
                            s.adjustZoom(delta: 0)
                        }
                        .keyboardShortcut("0", modifiers: .command)
                    }
                }
    }
}
