//
//  NestTab.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

enum NestTab: Identifiable, Hashable {
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

@Observable
class NestManager {
    var path: NavigationPath = NavigationPath()

    var searchRequest: SearchRequest = .init(
        address: "2500 University Drive NW",
        longitude: 51.0786839,
        latitude: -114.1355565,
        minPrice: 3e5,
        maxPrice: 5e5
    )
    private(set) var searchResults: [Listing] = []
    
    private var twig: Twig = .init()
    
    func computeSearchResults() {
        Task {
            searchResults = try await twig.searchListings(searchRequest)
            push(tab: .results)
        }
    }
    
    func push(tab: NestTab) {
        path.append(tab)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(tab: NestTab) -> some View {
        switch tab {
        case .search: SelectionView(nestManager: self)
        case .results: ResultsView(nestManager: self)
        case .listingDetail(let listing): ListingDetailView(nestManager: self, listing: listing)
        }
    }
}

