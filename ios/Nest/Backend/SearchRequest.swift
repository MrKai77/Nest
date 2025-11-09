//
//  SearchRequest.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

struct SearchRequest: Codable {
    // Required
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
