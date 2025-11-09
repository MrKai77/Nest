//
//  CreateListingRequest.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import Foundation

/// {
///     "price": 0,
///     "date_listed": "string",
///     "image_url": "string",
///     "longitude": 0,
///     "latitude": 0,
///     "address": "string",
///     "square_footage": 0,
///     "bathroom_num": 0,
///     "bedrooms_num": 0,
///     "backyard": true,
///     "garage": true,
///     "description": "string"
/// }

struct CreateListingRequest: Codable {
    var price: Double
    var dateListed: Date
    var imageUrl: URL?

    var longitude: Double
    var latitude: Double
    var address: String

    var squareFootage: Int?
    var bathroomNum: Int?
    var bedroomsNum: Int?
    var backyard: Bool?
    var garage: Bool?
    var description: String?

    enum CodingKeys: String, CodingKey {
        case price
        case dateListed = "date_listed"
        case imageUrl = "image_url"
        case longitude
        case latitude
        case address
        case squareFootage = "square_footage"
        case bathroomNum = "bathroom_num"
        case bedroomsNum = "bedrooms_num"
        case backyard
        case garage
        case description
    }
}
