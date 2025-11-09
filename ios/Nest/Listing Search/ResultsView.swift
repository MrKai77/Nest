//
//  ResultsView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ResultsView: View {
    let nestManager: NestManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(nestManager.searchResults.enumerated(), id: \.offset) { index, result in
                    Button {
                        nestManager.push(tab: .listingDetail(result))
                    } label: {
                        ListingView(listing: result)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 18)
                    
                    if index != nestManager.searchResults.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .navigationTitle("Results")
    }
}
