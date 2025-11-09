//
//  MyListingsManager.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI
import GeoToolbox
import CoreLocation
import Supabase
import Storage
import MapKit

@Observable
class MyListingsManager {
    private let locationManager: CLLocationManager
    private let client: SupabaseClient
    private var twig: Twig = .init() // TODO: use dependency injection
    var path: NavigationPath = NavigationPath()

    private(set) var userListings: [Listing] = []
    
    var creationRequest: CreateListingRequest
    var isSubmitting = false
    var lastSubmitSucceeded = false
    
    init() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        let client = SupabaseClient(
            supabaseURL: Env.SUPABASE_URL,
            supabaseKey: Env.SUPABASE_KEY
        )
        
        self.locationManager = locationManager
        self.client = client
        
        let currentLocation = locationManager.location?.coordinate
        
        creationRequest = .init(
            price: 100_000,
            dateListed: .now,
            imageUrl: nil,
            longitude: currentLocation?.longitude ?? 0,
            latitude: currentLocation?.latitude ?? 0,
            address: "",
            squareFootage: 1000,
            bathroomNum: 1,
            bedroomsNum: 1,
            backyard: false,
            garage: false,
            description: ""
        )
        
        if let coordinate = currentLocation {
            Task {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                if let locationName = await getLocationName(location: location) {
                    creationRequest.address = locationName
                }
            }
        }
    }

    // MARK: - Photo
    
    func setPhoto(to imageData: Data) async {
        if let url = await uploadPhoto(imageData) {
            creationRequest.imageUrl = url
        }
    }
    
    private func uploadPhoto(_ imageData: Data) async -> URL? {
        do {
            let fileName = "\(UUID().uuidString).jpg"
            let bucket = client.storage.from("listing-images")
            
            try await bucket.upload(
                fileName,
                data: imageData,
                options: FileOptions(contentType: "image/jpeg", upsert: true)
            )
            
            let publicURL = try bucket.getPublicURL(path: fileName)
            print("Uploaded successfully! Public URL: \(publicURL.absoluteString)")
            return publicURL
        } catch {
            print("Upload failed:", error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Reverse Geocoding
    
    func getLocationName(location: CLLocation) async -> String? {
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return nil
        }
        
        do {
            let mapItems = try await request.mapItems
            guard let item = mapItems.first else {
                return nil
            }
            let address = item.address?.shortAddress ?? item.address?.fullAddress
            return address
        } catch {
            print("Reverse geocoding failed:", error)
            return nil
        }
    }
    
    // MARK: - Submit
    
    @MainActor
    func createListing() async {
        lastSubmitSucceeded = false
        isSubmitting = true
        defer { isSubmitting = false }
        
        do {
            let listing = try await twig.uploadListing(creationRequest)
            userListings.append(listing)
            lastSubmitSucceeded = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Navigation

    func push(state: MyNestsState) {
        path.append(state)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(state: MyNestsState) -> some View {
        switch state {
        case .myListings: MyListingsList(manager: self)
        case .newListing: NewListingView(manager: self)
        case .listingDetail(let listing): PublishedListingDetailView(exit: { self.popToRoot() }, listing: listing)
        }
    }
}
