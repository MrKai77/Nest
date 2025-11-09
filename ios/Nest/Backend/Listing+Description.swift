//
//  Listing+Description.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import Foundation

extension Listing {
    func formattedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: price)) ?? "$\(Int(price))"
    }
    
    func propertyDetails() -> String {
        var parts: [String] = []
        if let bedrooms = bedroomsNum { parts.append("\(bedrooms) bedroom" + (bedrooms > 1 ? "s" : "")) }
        if let bathrooms = bathroomNum { parts.append("\(bathrooms) bathroom" + (bathrooms > 1 ? "s" : "")) }
        if let sqft = squareFootage { parts.append("\(sqft) sq. ft.") }
        return parts.joined(separator: ", ")
    }
    
    func amenitiesDescription() -> String {
        var parts: [String] = []
        if garage == true { parts.append("a garage") }
        if backyard == true { parts.append("a backyard") }
        if parts.isEmpty { return "" }
        return " and includes " + parts.joined(separator: " and ")
    }
    
    func generateDescription() -> String {
        let variants = [
            variant1(),
            variant2(),
            variant3(),
            variant4(),
            variant5()
        ]
        return variants.randomElement()!
    }
    
    private func variant1() -> String {
        let intros = [
            "Nestled in a peaceful neighborhood,",
            "Located in a lively part of the city,",
            "Set within a welcoming community,"
        ]
        let intro = intros.randomElement()!
        return "\(intro) this \(propertyDetails()) property at \(address) is listed for \(formattedPrice())\(amenitiesDescription()). A comfortable and inviting place to call home."
    }
    
    private func variant2() -> String {
        let openers = [
            "Discover the charm of",
            "Step inside",
            "Take a closer look at"
        ]
        let opener = openers.randomElement()!
        return "\(opener) this \(propertyDetails()) home at \(address), priced at \(formattedPrice()). It offers a perfect balance of comfort and convenience\(amenitiesDescription())."
    }
    
    private func variant3() -> String {
        let settings = [
            "Situated near shops and transit,",
            "Minutes from parks and schools,",
            "Tucked away on a quiet street,"
        ]
        let setting = settings.randomElement()!
        return "\(setting) this \(propertyDetails()) residence at \(address) is currently on the market for \(formattedPrice()). Thoughtfully designed\(amenitiesDescription()), it’s ready for its next owner."
    }
    
    private func variant4() -> String {
        return "At \(address), you’ll find a \(propertyDetails()) property listed for \(formattedPrice()). This home\(amenitiesDescription()) offers both style and practicality in a desirable location."
    }
    
    private func variant5() -> String {
        let tones = [
            "Ideal for families or first-time buyers,",
            "Perfect for those who value modern comfort,",
            "A wonderful opportunity for anyone seeking a balanced lifestyle,"
        ]
        let tone = tones.randomElement()!
        return "\(tone) this \(propertyDetails()) property at \(address) is offered at \(formattedPrice())\(amenitiesDescription()). A great fit for comfortable, everyday living."
    }
}
