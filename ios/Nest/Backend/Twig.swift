//
//  Twig.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import Foundation

final class Twig {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func checkConnection() async -> Bool {
        let pingURL = Env.AWS_URL.appendingPathComponent("ping")
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
        let url = Env.AWS_URL.appendingPathComponent("search_listings")
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
    
    /// Upload a new listing to the backend
    func uploadListing(_ listingRequest: CreateListingRequest) async throws -> Listing {
        let url = Env.AWS_URL.appendingPathComponent("create_listing")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(listingRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard (200..<300).contains(status) else {
            throw NSError(domain: "Twig", code: status, userInfo: [
                NSLocalizedDescriptionKey: "HTTP \(status)"
            ])
        }
        
        // Decode the returned listing (assumes backend returns the created listing)
        let createdListing = try Self.decoder.decode(Listing.self, from: data)
        return createdListing
    }
}
