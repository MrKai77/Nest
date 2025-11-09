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
        latitude: -114.1355565
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
    
    private let priceRange: ClosedRange<Double> = 0...1e6
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

    var body: some View {
        VStack {
            LocationSelectionView(location: placeDescriptorBinding)
                .clipShape(
                    .rect(
                        cornerRadii: .init(
                            topLeading: 12,
                            bottomLeading: 4,
                            bottomTrailing: 4,
                            topTrailing: 12
                        )
                    )
                )
                .frame(maxHeight: 300)
            
            Divider()
            
            HStack {
                Text("Price Range")

                RangedSliderView(
                    value: priceRangeBinding,
                    bounds: priceRange,
                    step: 1e4
                ) { value in
                    Text("$\(Text(value, format: .number.precision(.fractionLength(0))))")
                        .font(.caption)
                }
                .padding(.leading, 12)
                .padding(.trailing, 36)
            }
        }
        .padding(8)
        .background(
            .quinary,
            in: .rect(cornerRadius: 20)
        )
    }
}

#Preview {
    SelectionView()
        .padding(12)
}
