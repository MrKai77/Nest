//
//  NewListingView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-09.
//

import SwiftUI
import PhotosUI
import GeoToolbox

struct NewListingView: View {
    let manager: MyListingsManager
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    private let priceRange: ClosedRange<Double> = 100...25000
    private let bathroomsOptions = [1,2,3,4,5,6]
    private let bedroomsOptions = [1,2,3,4,5,6]
    
    // MARK: - Bindings to creationRequest
    
    private var priceBinding: Binding<Double> {
        Binding(
            get: { manager.creationRequest.price / 300 },
            set: { manager.creationRequest.price = $0 * 300 }
        )
    }
    
    private var squareFootageBinding: Binding<Double> {
        Binding(
            get: { Double(manager.creationRequest.squareFootage ?? 1000) },
            set: { manager.creationRequest.squareFootage = Int($0) }
        )
    }
    
    private var bathroomsBinding: Binding<Int> {
        Binding(
            get: { manager.creationRequest.bathroomNum ?? 1 },
            set: { manager.creationRequest.bathroomNum = $0 }
        )
    }
    
    private var bedroomsBinding: Binding<Int> {
        Binding(
            get: { manager.creationRequest.bedroomsNum ?? 1 },
            set: { manager.creationRequest.bedroomsNum = $0 }
        )
    }
    
    private var backyardBinding: Binding<Bool> {
        Binding(
            get: { manager.creationRequest.backyard ?? false },
            set: { manager.creationRequest.backyard = $0 }
        )
    }
    
    private var garageBinding: Binding<Bool> {
        Binding(
            get: { manager.creationRequest.garage ?? false },
            set: { manager.creationRequest.garage = $0 }
        )
    }
    
    private var descriptionBinding: Binding<String> {
        Binding(
            get: { manager.creationRequest.description ?? "" },
            set: { manager.creationRequest.description = $0 }
        )
    }
    
    // PlaceDescriptor binding bridging address + coordinates
    private var placeDescriptorBinding: Binding<PlaceDescriptor?> {
        Binding(
            get: {
                let coord = CLLocationCoordinate2D(
                    latitude: manager.creationRequest.latitude,
                    longitude: manager.creationRequest.longitude
                )
                return PlaceDescriptor(
                    representations: [.coordinate(coord)],
                    commonName: manager.creationRequest.address
                )
            },
            set: { newValue in
                if let lat = newValue?.coordinate?.latitude {
                    manager.creationRequest.latitude = lat
                }
                if let lon = newValue?.coordinate?.longitude {
                    manager.creationRequest.longitude = lon
                }
                if let addr = newValue?.address {
                    manager.creationRequest.address = addr
                } else if let name = newValue?.commonName {
                    manager.creationRequest.address = name
                }
            }
        )
    }
    
    var body: some View {
        VStack {
            Form {
                photoSection
                locationSection
                pricingSection
                detailsSection
                descriptionSection
            }
            
            if manager.lastSubmitSucceeded {
                Text("Listing created successfully!")
                    .foregroundStyle(.green)
                    .font(.footnote)
            }

            Button {
                Task {
                    await manager.createListing()
                    manager.popToRoot()
                }
            } label: {
                Text("Create Listing")
                    .padding(6)
                    .bold()
            }
            .padding()
            .buttonSizing(.flexible)
            .buttonStyle(.glassProminent)
            .disabled(manager.isSubmitting)
        }
        .navigationTitle("New Listing")
    }
    
    // MARK: Sections
    
    private var photoSection: some View {
        Section("Photo") {
            VStack(spacing: 12) {
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 180)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.secondary.opacity(0.3))
                        }
                        .padding(.bottom, 4)
                } else {
                    Text("No image selected")
                        .foregroundStyle(.secondary)
                }
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Photo", systemImage: "photo.on.rectangle.angled")
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            await manager.setPhoto(to: data)
                        }
                    }
                }
            }
        }
    }
    
    private var locationSection: some View {
        Section("Location") {
            LocationSelectionView(location: placeDescriptorBinding, showCircle: false)
                .frame(height: 240)
                .clipShape(.rect(cornerRadius: 10))

            if manager.creationRequest.address.isEmpty {
                Text("Address will appear once selected.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text(manager.creationRequest.address)
                    .font(.callout)
            }
        }
    }
    
    private var pricingSection: some View {
        Section("Pricing") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Monthly Price")
                    Spacer()
                    
                    let priceText = Text(
                        priceBinding.wrappedValue,
                        format: .number.precision(.fractionLength(0))
                    )

                    Text("$\(priceText)")
                        .foregroundStyle(.secondary)
                }
                Slider(value: priceBinding, in: priceRange, step: 500)
                
                TextField("Custom price", value: priceBinding, format: .number.precision(.fractionLength(2)))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
            
            LabeledContent("Date Listed") {
                Text(manager.creationRequest.dateListed, format: .dateTime.year().month().day())
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var detailsSection: some View {
        Section("Details") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Square Footage")
                    Spacer()
                    Text("\(Int(squareFootageBinding.wrappedValue)) sq ft")
                        .foregroundStyle(.secondary)
                }
                Slider(value: squareFootageBinding, in: 300...10_000, step: 50)
            }
            
            Picker("Bathrooms", selection: bathroomsBinding) {
                ForEach(bathroomsOptions, id: \.self) { num in
                    Text("\(num)")
                }
            }
            
            Picker("Bedrooms", selection: bedroomsBinding) {
                ForEach(bedroomsOptions, id: \.self) { num in
                    Text("\(num)")
                }
            }
            
            Toggle("Backyard", isOn: backyardBinding)
            Toggle("Garage", isOn: garageBinding)
        }
    }
    
    private var descriptionSection: some View {
        Section("Description") {
            TextEditor(text: descriptionBinding)
                .frame(minHeight: 160)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3))
                )
            
            if (manager.creationRequest.description ?? "").isEmpty {
                Text("Add details about the property for potential buyers.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
