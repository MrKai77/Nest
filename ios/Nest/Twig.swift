//
//  Twig.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import Foundation

// MARK: - Request Model

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

// MARK: - Response Models
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

struct ListingsResponse: Codable {
    let listings: [Listing]
}

// MARK: - API Client

final class Twig {
    private static let endpoint: URL = URL(string: "https://pnhacu5mrr.us-east-1.awsapprunner.com")!
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func checkConnection() async -> Bool {
        let pingURL = Self.endpoint.appendingPathComponent("ping")
        var request = URLRequest(url: pingURL)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
            return String(data: data, encoding: .utf8) == "Hello world"
        } catch {
            return false
        }
    }
    
    func searchListings(_ searchRequest: SearchRequest) async throws -> [Listing] {
        let url = Self.endpoint.appendingPathComponent("search_listings")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(searchRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200..<300).contains(status) else {
            throw NSError(domain: "Twig", code: status, userInfo: [
                NSLocalizedDescriptionKey: "HTTP \(status)"
            ])
        }
        
        let listingsResponse = try Self.decoder.decode(ListingsResponse.self, from: data)
        return listingsResponse.listings
    }
}
