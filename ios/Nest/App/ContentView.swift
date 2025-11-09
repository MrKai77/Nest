//
//  ContentView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    let coordinator = NestCoordinator()

    var body: some View {
//        VStack {
//            Button("Check connection") {
//                Task {
//                    await print(twig.checkConnection())
//                }
//            }
//            
//            Button("Get listings") {
//                Task {
//                    try! await print(
//                        twig.searchListings(
//                            .init(
//                                address: "119 William Street NW",
//                                longitude: 100,
//                                latitude: 100,
//                                squareFootage: 0,
//                                bathroomNum: 0,
//                                bedroomsNum: 0,
//                                backyard: nil,
//                                garage: nil,
//                                minPrice: 0,
//                                maxPrice: 0
//                            )
//                        )
//                    )
//                }
//            }
//        }
        @Bindable var coordinator = coordinator
        
        TabView(selection: $coordinator.currentTab) {
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                SearchView()
            }
            
            Tab("My Listings", systemImage: "storefront", value: .publishedListings) {
                NewListingView()
            }
            
            Tab("Profile", systemImage: "person", value: .profile) {
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
