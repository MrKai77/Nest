//
//  MyListingsView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

struct MyListingsView: View {
    let manager: MyListingsManager = .init()

    var body: some View {
        @Bindable var manager = manager
        NavigationStack(path: $manager.path) {
            manager.build(state: .myListings)
                .navigationDestination(for: MyNestsState.self) { tab in
                    manager.build(state: tab)
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
