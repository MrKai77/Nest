//
//  ResultsView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ResultsView: View {
    let nestManager: NestSearchManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(nestManager.searchResults.enumerated(), id: \.offset) { index, result in
                    let images: [ImageResource] = [
                        .image1, .image2, .image3, .image4, .image5, .image6, .image7, .image8, .image9
                    ]
                    
                    let image = Image(images.randomElement()!)

                    Button {
                        nestManager.push(state: .listingDetail(result, image))
                    } label: {
                        ListingView(listing: result, image: image)
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
