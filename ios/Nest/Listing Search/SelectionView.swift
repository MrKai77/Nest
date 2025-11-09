//
//  SelectionView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import CoreLocation
import SwiftUI
import GeoToolbox
import MapKit

struct SelectionView: View {
    let nestManager: NestManager
    
    private var placeDescriptorBinding: Binding<PlaceDescriptor?> {
        .init(
            get: {
                let coordinate: CLLocationCoordinate2D = .init(
                    latitude: nestManager.searchRequest.latitude,
                    longitude: nestManager.searchRequest.longitude
                )
                return .init(
                    representations: [
                        .coordinate(coordinate)
                    ],
                    commonName: nestManager.searchRequest.address
                )
            },
            set: { newDescriptor in
                if let latitude = newDescriptor?.coordinate?.latitude {
                    nestManager.searchRequest.latitude = latitude
                }
                
                if let longitude = newDescriptor?.coordinate?.longitude {
                    nestManager.searchRequest.longitude = longitude
                }
                
                if let address = newDescriptor?.address {
                    nestManager.searchRequest.address = address
                }
            }
        )
    }
    
    private let priceRange: ClosedRange<Double> = 1e2...1e6
    private var priceRangeBinding: Binding<ClosedRange<Double>> {
        .init(
            get: {
                (nestManager.searchRequest.minPrice ?? priceRange.lowerBound)...(nestManager.searchRequest.maxPrice ?? priceRange.upperBound)
            },
            set: { newRange in
                nestManager.searchRequest.minPrice = newRange.lowerBound
                nestManager.searchRequest.maxPrice = newRange.upperBound
            }
        )
    }
    
    private let bathroomsOptions: [Int] = [1, 2, 3, 4, 5]
    private var bathroomsBinding: Binding<Int> {
        .init(
            get: { nestManager.searchRequest.bathroomNum ?? 1 },
            set: { nestManager.searchRequest.bathroomNum = $0 }
        )
    }
    
    private let bedroomsOptions: [Int] = [1, 2, 3, 4, 5]
    private var bedroomsBinding: Binding<Int> {
        .init(
            get: { nestManager.searchRequest.bedroomsNum ?? 1 },
            set: { nestManager.searchRequest.bedroomsNum = $0 }
        )
    }
    
    private var squareFootageBinding: Binding<Double> {
        .init(
            get: { Double(nestManager.searchRequest.squareFootage ?? 1800) },
            set: { nestManager.searchRequest.squareFootage = Int($0) }
        )
    }
    
    private var backyardBinding: Binding<Bool> {
        .init(
            get: { nestManager.searchRequest.backyard ?? false },
            set: { nestManager.searchRequest.backyard = $0 }
        )
    }

    private var garageBinding: Binding<Bool> {
        .init(
            get: { nestManager.searchRequest.garage ?? false },
            set: { nestManager.searchRequest.garage = $0 }
        )
    }

    var body: some View {
        ScrollView {
            VStack {
                settings
                    .padding(.top, -24)
                    .frame(height: 840)
                
                Button {
                    nestManager.computeSearchResults()
                } label: {
                    Text("Search…")
                        .padding(6)
                        .bold()
                }
                .padding()
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .padding(.top, -48)
            }
        }
        .navigationTitle("Search Listings")
       
    }
    
    private var settings: some View {
        Form {
            Section {
                LocationSelectionView(location: placeDescriptorBinding)
                    .clipShape(
                        .rect(cornerRadius: 8)
                    )
                    .frame(height: 280)
            }

            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Price Range")
                        
                        Spacer()
                        
                        let lowerRangeText = Text(
                            priceRangeBinding.wrappedValue.lowerBound,
                            format: .number.precision(.fractionLength(0))
                        )
                        
                        let upperRangeText = Text(
                            priceRangeBinding.wrappedValue.upperBound,
                            format: .number.precision(.fractionLength(0))
                        )
                        
                        Text("$\(lowerRangeText) - $\(upperRangeText)")
                            .foregroundStyle(.secondary)
                    }
                    
                    RangedSliderView(
                        value: priceRangeBinding,
                        bounds: priceRange,
                        step: 1e4
                    )
                    .padding(.leading, 12)
                    .padding(.trailing, 36)
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("Square footage")
                        
                        Spacer()
                        
                        let squareFootageText = Text(
                            squareFootageBinding.wrappedValue,
                            format: .number.precision(.fractionLength(0))
                        )
                        
                        Text("\(squareFootageText) sq. ft.")
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(
                        value: squareFootageBinding,
                        in: 100...6000
                    )
                }
            }
            
            Section {
                Picker(
                    "Bathrooms",
                    selection: bathroomsBinding
                ) {
                    ForEach(bathroomsOptions, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                
                
                Picker(
                    "Bedrooms",
                    selection: bedroomsBinding
                ) {
                    ForEach(bedroomsOptions, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                
                Toggle("Has backyard", isOn: backyardBinding)
                Toggle("Has garage", isOn: garageBinding)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
    }
}
