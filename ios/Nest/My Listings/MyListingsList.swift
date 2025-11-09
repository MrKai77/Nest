//
//  MyListingsList.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

struct MyListingsList: View {
    let manager: MyListingsManager
    
    var body: some View {
        VStack {
            Form {
                ForEach(manager.userListings) { listing in
                    Button {
                        manager.push(state: .listingDetail(listing))
                    } label: {
                        PublishedListingView(listing: listing, isOccupied: .random())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Button {
                manager.push(state: .newListing)
            } label: {
                Text("Make new listing")
                    .padding(6)
                    .bold()
            }
            .padding()
            .buttonSizing(.flexible)
            .buttonStyle(.glassProminent)
        }
        .navigationTitle("My Listings")
    }
}
