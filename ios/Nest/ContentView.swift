//
//  ContentView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    let nestManager = NestManager()

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
//        .padding()
        
        @Bindable var nestManager = nestManager
        NavigationStack(path: $nestManager.path) {
            nestManager.build(tab: .search)
                .navigationDestination(for: NestTab.self) { tab in
                    nestManager.build(tab: tab)
                }
        }
    }
}

#Preview {
    ContentView()
}
