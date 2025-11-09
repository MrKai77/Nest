//
//  ListingDetailView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ListingDetailView: View {
    let nestManager: NestManager
    let listing: Listing

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 300)
                    .foregroundStyle(.quaternary)
                    .overlay {
                        AsyncImage(
                            url: listing.imageUrl
                        ) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure(_):
                                ProgressView()
                            @unknown default:
                                ProgressView()
                            }
                        }
                    }
                    .clipped()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(listing.address)
                            .font(.body)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            if let squareFootage = listing.squareFootage {
                                Text("\(squareFootage) sq. ft.")
                            }
                            
                            if let bathrooms = listing.bathroomNum {
                                Text("^[\(bathrooms) bathroom](inflect: true).")
                            }
                            
                            if let bedrooms = listing.bedroomsNum {
                                Text("^[\(bedrooms) bedroom](inflect: true).")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading) {
                            let hasBackyard = listing.backyard == true // Removes optional
                            let hasGarage = listing.garage == true // Removes optional
                            
                            Text("\(Image(systemName: "\(hasBackyard ? "checkmark" : "xmark").circle")) Backyard")
                            Text("\(Image(systemName: "\(hasGarage ? "checkmark" : "xmark").circle")) Garage")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    HStack {
                        Text("Landlord rating")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        StarRatingView()
                    }
                    
                    Divider()
                    
                    Text(listing.generateDescription())
                    
                    Divider()
                    
                    Text("Last updated: \(Text(listing.dateListed, format: .dateTime))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(12)
            }
        }
        .safeAreaBar(edge: .bottom) {
            // Spread the payment across roughly 300 months for a rental price
            let price = Text(listing.price / 300, format: .number.precision(.fractionLength(0)))

            Button {
                nestManager.popToRoot()
            } label: {
                Text("Rent for $\(price)/month…")
                    .padding(6)
                    .bold()
            }
            .padding()
            .buttonSizing(.flexible)
            .buttonStyle(.glassProminent)
            .padding(.top, -48)
        }
    }
}
