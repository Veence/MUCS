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
    
    // List categories of components

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView(s: s)
        }
        .modelContainer(sharedModelContainer)
        .commands {
                    // This adds a new section to the native macOS menus
                    CommandMenu("View") {
                        Button("Zoom In") {
                            s.zoomIn()
                        }
                        .keyboardShortcut("+", modifiers: .command)
                        

                        Button("Zoom Out") {
                            s.zoomOut()
                        }
                        .keyboardShortcut("-", modifiers: .command)
                        
                        Divider()
                        
                        Button("Reset Zoom") {
                            s.resetZoom()
                        }
                        .keyboardShortcut("0", modifiers: .command)
                    }
                }
    }
}
