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
    @State var currentSearchRequest: SearchRequest = .init(
        address: "2500 University Drive NW",
        longitude: 51.0786839,
        latitude: -114.1355565,
        minPrice: 3e5,
        maxPrice: 4e5
    )
    
    private var placeDescriptorBinding: Binding<PlaceDescriptor?> {
        .init(
            get: {
                let coordinate: CLLocationCoordinate2D = .init(
                    latitude: currentSearchRequest.latitude,
                    longitude: currentSearchRequest.longitude
                )
                return .init(
                    representations: [
                        .coordinate(coordinate)
                    ],
                    commonName: currentSearchRequest.address
                )
            },
            set: { newDescriptor in
                if let latitude = newDescriptor?.coordinate?.latitude {
                    currentSearchRequest.latitude = latitude
                }
                
                if let longitude = newDescriptor?.coordinate?.longitude {
                    currentSearchRequest.longitude = longitude
                }
                
                if let address = newDescriptor?.address {
                    currentSearchRequest.address = address
                }
            }
        )
    }
    
    private let priceRange: ClosedRange<Double> = 1e2...1e6
    private var priceRangeBinding: Binding<ClosedRange<Double>> {
        .init(
            get: {
                (currentSearchRequest.minPrice ?? priceRange.lowerBound)...(currentSearchRequest.maxPrice ?? priceRange.upperBound)
            },
            set: { newRange in
                currentSearchRequest.minPrice = newRange.lowerBound
                currentSearchRequest.maxPrice = newRange.upperBound
            }
        )
    }
    
    private let bathroomsOptions: [Int] = [1, 2, 3, 4, 5]
    private var bathroomsBinding: Binding<Int> {
        .init(
            get: { currentSearchRequest.bathroomNum ?? 1 },
            set: { currentSearchRequest.bathroomNum = $0 }
        )
    }
    
    private let bedroomsOptions: [Int] = [1, 2, 3, 4, 5]
    private var bedroomsBinding: Binding<Int> {
        .init(
            get: { currentSearchRequest.bedroomsNum ?? 1 },
            set: { currentSearchRequest.bedroomsNum = $0 }
        )
    }
    
    private var squareFootageBinding: Binding<Double> {
        .init(
            get: { Double(currentSearchRequest.squareFootage ?? 1800) },
            set: { currentSearchRequest.squareFootage = Int($0) }
        )
    }
    
    private var backyardBinding: Binding<Bool> {
        .init(
            get: { currentSearchRequest.backyard ?? false },
            set: { currentSearchRequest.backyard = $0 }
        )
    }

    private var garageBinding: Binding<Bool> {
        .init(
            get: { currentSearchRequest.garage ?? false },
            set: { currentSearchRequest.garage = $0 }
        )
    }

    var body: some View {
        ScrollView {
            VStack {
                settings
                    .padding(.top, -24)
                    .frame(height: 760)
                
                Button {
                    print("A")
                } label: {
                    Text("Search…")
                        .padding(6)
                }
                .padding()
                .buttonSizing(.flexible)
                .buttonStyle(.glassProminent)
                .padding(.top, -48)
            }
        }
    }
    
    private var settings: some View {
        Form {
            LocationSelectionView(location: placeDescriptorBinding)
                .clipShape(
                    .rect(cornerRadius: 8)
                )
                .frame(height: 280)

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
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
    }
}

#Preview {
    SelectionView()
}
