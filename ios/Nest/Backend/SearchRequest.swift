//
//  SearchRequest.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

/// {
///     "description": "string",
///     "address": "2500 University Drive NW",
///     "longitude": -114.0878040762618,
///     "latitude": 51.074423947238024,
///     "square_footage": 2564,
///     "bathroom_num": 2,
///     "bedrooms_num": 3,
///     "backyard": true,
///     "garage": true,
///     "min_price": 180100,
///     "max_price": 960100
/// }

struct SearchRequest: Codable {
    // Required
    var description: String = "string"
    var address: String
    var longitude: Double
    var latitude: Double
    
    // Optional amenities
    var squareFootage: Int?
    var bathroomNum: Int?
    var bedroomsNum: Int?
    var backyard: Bool?
    var garage: Bool?
    
    // Optional price range
    var minPrice: Double?
    var maxPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case description
        case address
        case longitude
        case latitude
        case squareFootage = "square_footage"
        case bathroomNum = "bathroom_num"
        case bedroomsNum = "bedrooms_num"
        case backyard
        case garage
        case minPrice = "min_price"
        case maxPrice = "max_price"
    }
}
