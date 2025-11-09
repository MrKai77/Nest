//
//  RangedSliderView.swift
//  Nest
//
//  Created by Kai Azim on 2025-11-08.
//

import SwiftUI

/// Loosely based off of https://stackoverflow.com/questions/62587261/how-to-create-a-two-handle-range-slider
struct RangedSliderView<V>: View where V: BinaryFloatingPoint {
    @Environment(\.colorScheme) var colorScheme
    
    let currentValue: Binding<ClosedRange<V>>
    let sliderBounds: ClosedRange<V>
    let step: V
//    let label: (_ value: V) -> Label
    
    public init(
        value: Binding<ClosedRange<V>>,
        bounds: ClosedRange<V>,
        step: V = 1,
//        @ViewBuilder label: @escaping (_ value: V) -> Label
    ) {
        self.currentValue = value
        self.sliderBounds = bounds
        self.step = step
//        self.label = label
    }
    
    var body: some View {
        GeometryReader { geometry in
            sliderView(sliderSize: geometry.size)
        }
        // Thse paddings compensate for the top and bottom of the slider thumbs
//        .padding(.vertical, 30)
        .frame(height: 30)
        .padding(.horizontal, -6)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        let totalSteps = (sliderBounds.upperBound - sliderBounds.lowerBound) / step
        let stepWidthInPixels = sliderSize.width / CGFloat(totalSteps)
        
        ZStack {
            Capsule()
                .foregroundStyle(.quinary.opacity(0.6))
                .frame(height: 6)
                .padding(.leading, -6)
                .padding(.trailing, -24)
            
            let leftThumbX = CGFloat((currentValue.wrappedValue.lowerBound - sliderBounds.lowerBound) / step) * stepWidthInPixels + 12
            let rightThumbX = CGFloat((currentValue.wrappedValue.upperBound - sliderBounds.lowerBound) / step) * stepWidthInPixels + 6
            
            let distanceX = rightThumbX - leftThumbX
            
            lineBetweenThumbs(
                from: CGPoint(x: leftThumbX, y: sliderViewYCenter),
                to: CGPoint(x: rightThumbX, y: sliderViewYCenter)
            )
            
            // Left Thumb
            thumbView(
                position: CGPoint(x: leftThumbX, y: sliderViewYCenter),
                value: currentValue.wrappedValue.lowerBound,
                onTop: true,
                distance: distanceX
            )
            .highPriorityGesture(
                DragGesture()
                    .onChanged { drag in
                        let location = min(max(0, drag.location.x), sliderSize.width)
                        let steppedIndex = round(location / stepWidthInPixels)
                        let newValue = sliderBounds.lowerBound + V(steppedIndex) * step
                        
                        if newValue < currentValue.wrappedValue.upperBound {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    }
            )
            
            // Right Thumb
            thumbView(
                position: CGPoint(x: rightThumbX, y: sliderViewYCenter),
                value: currentValue.wrappedValue.upperBound,
                onTop: false,
                distance: distanceX
            )
            .highPriorityGesture(
                DragGesture()
                    .onChanged { drag in
                        let location = min(max(leftThumbX, drag.location.x), sliderSize.width)
                        let steppedIndex = round(location / stepWidthInPixels)
                        let newValue = sliderBounds.lowerBound + V(steppedIndex) * step
                        
                        if newValue > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                        }
                    }
            )
        }
    }
    
    private func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(Color.accentColor, lineWidth: 6)
    }
    
    private func thumbView(position: CGPoint, value: V, onTop: Bool, distance: Double) -> some View {
        ZStack {
//            label(value)
//                .offset(y: 25 * (onTop ? -1.0 : 1.0))
            
            let scale = min(1, max(0.4, (distance / 36) - 0.1))
            
            Capsule()
                .frame(width: 36, height: 24)
                .foregroundStyle(.white)
                .shadow(radius: 5)
                .contentShape(Rectangle())
                .scaleEffect(scale)
        }
        .position(x: position.x, y: position.y)
    }
}

#Preview {
    @Previewable @State var selection: ClosedRange<Float> = 5...25

    RangedSliderView(
        value: $selection,
        bounds: 0...100,
        step: 5
    )
//    ) { value in
//        Text("\(value)")
//            .font(.callout)
//    }
    .padding(12)
}
