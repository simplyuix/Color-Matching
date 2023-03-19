import SwiftUI

struct ColorCircle: View {
    @Binding var color: Color
    @Binding var offset: CGSize
    @State private var initialDragLocation: CGPoint = .zero
    @State private var initialHue: CGFloat = 0.0
    @State private var initialBrightness: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(color)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(offset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            if initialDragLocation == .zero {
                                initialDragLocation = drag.startLocation
                                let (hue, _, brightness, _) = color.uiColor.hsba
                                initialHue = hue
                                initialBrightness = brightness
                            }
                            updateColor(for: drag, in: geometry)
                            updateOffset(for: drag, in: geometry)
                        }
                        .onEnded { _ in
                            initialDragLocation = .zero
                        }
                )
        }
    }

    private func updateColor(for drag: DragGesture.Value, in geometry: GeometryProxy) {
        let (_, targetSaturation, _, _) = color.uiColor.hsba

        // Update hue
        let hueChangeFactor: CGFloat = 0.001
        let hueDelta = CGFloat(drag.location.x - initialDragLocation.x) * hueChangeFactor
        var newHue = initialHue + hueDelta
        
        while newHue < 0 {
            newHue += 1
        }
        while newHue > 1 {
            newHue -= 1
        }

        // Update brightness
        let brightnessChangeFactor: CGFloat = 0.001
        let brightnessDelta = CGFloat(initialDragLocation.y - drag.location.y) * brightnessChangeFactor
        var newBrightness = initialBrightness + brightnessDelta

        newBrightness = min(max(0, newBrightness), 1)

        color = Color(UIColor(hue: newHue, saturation: targetSaturation, brightness: newBrightness, alpha: 1))
    }

    private func updateOffset(for drag: DragGesture.Value, in geometry: GeometryProxy) {
        let width = geometry.size.width
        let height = geometry.size.height

        let dx = drag.translation.width / width
        let dy = drag.translation.height / height

        offset.width += dx * width
        offset.height += dy * height
    }
}

struct ColorCircle_Previews: PreviewProvider {
    static var previews: some View {
        ColorCircle(color: .constant(Color.red), offset: .constant(.zero))
    }
}
