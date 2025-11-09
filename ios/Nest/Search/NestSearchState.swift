//
//  NestSearchState.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import Foundation

enum NestSearchState: Identifiable, Hashable {
    case search
    case results
    case listingDetail(Listing)
    
    var id: String {
        switch self {
        case .search: "search"
        case .results: "results"
        case .listingDetail(let listing): listing.id
        }
    }
}
