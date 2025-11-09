//
//  StarRatingView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct StarRatingView: View {
    private let rating: Int
    private let maxStars = 5

    init() {
        // Bias toward higher ratings
        let exponent = 0.5
        let u = Double.random(in: 0...1)
        let biased = pow(u, exponent)
        let scaled = Int(round(biased * Double(maxStars - 1))) + 1
        self.rating = min(maxStars, max(1, scaled))
    }

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...maxStars, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(.yellow)
            }
        }
    }
}
