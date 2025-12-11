//
//  Categories.swift
//  MUCS
//
//  Created by Vincent on 07/12/2025.
//

import Foundation

struct Category: Identifiable {
    let id: UUID = UUID()
    let name: String
    let components: [@MainActor () -> any Component]
}

// Dictionary of components

let categories: [Category] = [
    .init(name:"Lumped", components: [
            ResistorWiggle.init,
            ResistorBox.init
        ])
]

