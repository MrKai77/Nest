//
//  ContentView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    let coordinator = NestCoordinator()
    let twig = Twig()

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
//                                address: "880 Crowchild Tr NW",
//                                longitude: -114.22050718668,
//                                latitude: 51.0404559134111,
//                                squareFootage: 3050,
//                                bathroomNum: 4,
//                                bedroomsNum: 5,
//                                backyard: true,
//                                garage: false,
//                                minPrice: 1252000,
//                                maxPrice: 1252300
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
                MyListingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
