//
//  PublishedListingView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI

struct PublishedListingView: View {
    let listing: Listing
    let isOccupied: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
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
                    
                    let price = Text(listing.pricePerMonth, format: .number.precision(.fractionLength(0)))

                    Text("$\(price)/month")
                        .font(.headline.bold())
                }
                
                if isOccupied {
                    let calendar = Calendar.current
                    let randomDate = calendar.startOfDay(
                        for: calendar.date(
                            byAdding: .day,
                            value: .random(in: 1...30),
                            to: Date()
                        )!
                    )
                    let formattedDate = Text(randomDate, format: .dateTime)
                    
                    
                    Text("\(Image(systemName: "clock.badge.fill")) Occupied unil \(formattedDate)")
                        .foregroundStyle(.nestGreen)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
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
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .font(.caption)
                
                Text("You last updated: \(Text(listing.dateListed, format: .dateTime))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 300)
        .contentShape(.rect)
    }
}

#Preview {
    VStack {
        PublishedListingView(
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
            ),
            isOccupied: true
        )
        .padding(12)
    }
}
