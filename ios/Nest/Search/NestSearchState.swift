//
//  NestSearchState.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

enum NestSearchState: Identifiable, Hashable {
    case search
    case results
    case listingDetail(Listing, Image)
    
    var id: String {
        switch self {
        case .search: "search"
        case .results: "results"
        case .listingDetail(let listing, let image): listing.id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .search:
            hasher.combine(0)
        case .results:
            hasher.combine(1)
        case .listingDetail(let listing, let image):
            hasher.combine(2)
            hasher.combine(listing.id)
        }
    }
}
