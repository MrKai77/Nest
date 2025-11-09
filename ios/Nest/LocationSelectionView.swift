//
//  LocationSelectionView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import CoreLocation
import SwiftUI
import GeoToolbox
import MapKit

import SwiftUI
import MapKit

struct LocationSelectionView: View {
    @Binding var location: PlaceDescriptor?
    
    @State private var selectedItem: MapFeature?
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // city-level zoom
        )
    )
    
    private let locationManager = CLLocationManager()
    
    var body: some View {
        Map(
            position: $cameraPosition,
            selection: $selectedItem
        ) {
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
        }
        .contentMargins(12)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            
            // Optionally zoom to user's location once available
            if let coordinate = locationManager.location?.coordinate {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
        .onChange(of: selectedItem) {
            if let coordinate = selectedItem?.coordinate {
                location = .init(
                    representations: [
                        .coordinate(coordinate)
                    ],
                    commonName: selectedItem?.title
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var place: PlaceDescriptor? = PlaceDescriptor(
        representations: [
            .address("2500 University Drive NW")
        ],
        commonName: "University of Calgary"
    )

    VStack {
        LocationSelectionView(
            location: $place
        )
    }
}
