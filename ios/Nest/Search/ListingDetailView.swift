//
//  ListingDetailView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ListingDetailView: View {
    let nestManager: NestSearchManager
    let listing: Listing
    let image: Image

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 350)
                    .foregroundStyle(.quaternary)
                    .overlay {
//                        AsyncImage(url: listing.imageUrl) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(maxWidth: .infinity)
//                                    .clipped()
//                            case .failure:
//                                Image(systemName: "photo")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .padding()
//                                    .foregroundStyle(.secondary)
//                            @unknown default:
//                                EmptyView()
//                            }
//                        }
                        image
                            .resizable()
                            .scaledToFill()
                    }
                
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

                            HStack {
                                if hasBackyard {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundStyle(.nestGreen)
                                } else {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.nestRed)
                                }
                                
                                Text("Backyard")
                            }
                            
                            HStack {
                                if hasGarage {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundStyle(.nestGreen)
                                } else {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.nestRed)
                                }
                                
                                Text("Garage")
                            }
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
        .ignoresSafeArea()
        .safeAreaBar(edge: .bottom) {
            let price = Text(listing.pricePerMonth, format: .number.precision(.fractionLength(0)))

            VStack {
                Button {
                    nestManager.popToRoot()
                } label: {
                    Text("Rent for $\(price)/month…")
                        .padding(6)
                        .bold()
                }
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                
                Text("Your personal information will stay completely private from the seller, ensuring a fair and unbiased process. \(Text("Learn more…").foregroundStyle(.accent))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}
