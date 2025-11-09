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
            VStack {
                ForEach(nestManager.searchResults) { result in
                    Button {
                        nestManager.push(tab: .listingDetail(result))
                    } label: {
                        ListingView(listing: result)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("Results")
    }
}
