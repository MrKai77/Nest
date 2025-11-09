//
//  SearchView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

struct SearchView: View {
    let nestManager = NestSearchManager()
    
    var body: some View {
        @Bindable var nestManager = nestManager
        NavigationStack(path: $nestManager.path) {
            nestManager.build(state: .search)
                .navigationDestination(for: NestSearchState.self) { tab in
                    nestManager.build(state: tab)
                        .background(content: background)
                }
                .background(content: background)
        }
    }
    
    private func background() -> some View {
        LinearGradient(
            colors: [
                .accent.opacity(0.1),
                .accent.opacity(0.05),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
