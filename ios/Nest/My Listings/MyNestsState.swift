//
//  MyNestsState.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

enum MyNestsState: Identifiable, Hashable {
    case myListings
    case newListing
    case listingDetail(Listing)
    
    var id: String {
        switch self {
        case .myListings: "listings"
        case .newListing: "newListing"
        case .listingDetail(let listing): listing.id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .myListings:
            hasher.combine(0)
        case .newListing:
            hasher.combine(1)
        case .listingDetail(let listing):
            hasher.combine(2)
            hasher.combine(listing.id)
        }
    }
}
