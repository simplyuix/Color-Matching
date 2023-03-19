import SwiftUI
import UIKit

extension Color {
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1),
                     green: Double.random(in: 0...1),
                     blue: Double.random(in: 0...1))
    }
    
    func isSimilar(to other: Color, tolerance: Double) -> Bool {
        let (r1, g1, b1, _) = self.uiColor.components
        let (r2, g2, b2, _) = other.uiColor.components

        let deltaR = abs(r1 - r2)
        let deltaG = abs(g1 - g2)
        let deltaB = abs(b1 - b2)

        return deltaR <= tolerance && deltaG <= tolerance && deltaB <= tolerance
    }

    func randomColorCloseBy(tolerance: Double = 0.1) -> Color {
        let (r, g, b, _) = self.uiColor.components
        let randomRed = Double(max(0, min(1, r + CGFloat.random(in: -CGFloat(tolerance)...CGFloat(tolerance)))))
        let randomGreen = Double(max(0, min(1, g + CGFloat.random(in: -CGFloat(tolerance)...CGFloat(tolerance)))))
        let randomBlue = Double(max(0, min(1, b + CGFloat.random(in: -CGFloat(tolerance)...CGFloat(tolerance)))))

        return Color(red: randomRed, green: randomGreen, blue: randomBlue)
    }

    var uiColor: UIColor {
        return UIColor(self)
    }
}

extension UIColor {
    var components: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }
}
extension CGColor {
    var componentsNormalized: (CGFloat, CGFloat, CGFloat, CGFloat) {
        let ciColor = CIColor(cgColor: self)
        return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
    }
}
