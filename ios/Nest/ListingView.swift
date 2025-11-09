//
//  ListingView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct ListingView: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
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
                .clipShape(
                    .rect(
                        cornerRadii: .init(
                            topLeading: 12,
                            bottomLeading: 4,
                            bottomTrailing: 4,
                            topTrailing: 12
                        )
                    )
                )
            
            HStack {
                Text(listing.address)
                    .font(.body)
                
                Spacer()

                Text(listing.price, format: .currency(code: "CAD"))
                    .font(.headline.bold())
            }
            
            Divider()
            
            HStack(alignment: .top, spacing: 0) {
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
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .font(.caption)
            
            Divider()
            
            Text("Last updated: \(Text(listing.dateListed, format: .dateTime))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(height: 300)
        .padding(8)
        .background(
            .quinary,
            in: .rect(
                cornerRadii: .init(
                    topLeading: 20,
                    bottomLeading: 12,
                    bottomTrailing: 12,
                    topTrailing: 20
                )
            )
        )
    }
}

#Preview {
    VStack {
        ListingView(
            listing: Listing(
                id: UUID().uuidString,
                longitude: 54.01,
                latitude: 49.22,
                address: "119 William Street NW",
                price: 899990,
                dateListed: .now.addingTimeInterval(-3600),
                imageUrl: URL(string: "https://www.bcre.com/uploads/agent-77/Haight_Ashury_San_Francisco_Home.jpg")!,
                squareFootage: 1400,
                bathroomNum: 2,
                bedroomsNum: 1,
                backyard: true,
                garage: false
            )
        )
        .padding(12)
    }
}
