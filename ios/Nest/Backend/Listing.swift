//
//  Listing.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

/// {
///     "listings": [
///         {
///             "id": "string",
///             "price": 0,
///             "date_listed": "string",
///             "image_url": "string",
///             "longitude": 0,
///             "latitude": 0,
///             "address": "string",
///             "square_footage": 0,
///             "bathroom_num": 0,
///             "bedrooms_num": 0,
///             "backyard": true,
///             "garage": true
///         }
///     ]
/// }

struct Listing: Identifiable, Codable, Hashable {
    let id: String
    let longitude: Double
    let latitude: Double
    let address: String
    let price: Double
    let dateListed: Date
    let imageUrl: URL?
    
    // Optional amenities
    let squareFootage: Int?
    let bathroomNum: Int?
    let bedroomsNum: Int?
    let backyard: Bool?
    let garage: Bool?
    
    var pricePerMonth: Double {
        price / 300
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case longitude
        case latitude
        case address
        case price
        case dateListed = "date_listed"
        case imageUrl = "image_url"
        case squareFootage = "square_footage"
        case bathroomNum = "bathroom_num"
        case bedroomsNum = "bedrooms_num"
        case backyard
        case garage
    }
}
