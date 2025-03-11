import SwiftUI

struct ContentView: View {
    @State private var selectedColor: NSColor = .clear
    @State private var hexValue: String = "#000000"
    @State private var rgbValue: String = "0, 0, 0"
    @State private var hslValue: String = "0°, 0%, 0%"
    @State private var tailwindColor: String = "None"
    @State private var isPicking: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Color is fun")
                .font(.headline)
                .padding(.top)
            
            ColorPreview(color: selectedColor)
                .frame(height: 80)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                ColorInfoRow(label: "Tailwind", value: tailwindColor)
                ColorInfoRow(label: "HEX", value: hexValue)
                ColorInfoRow(label: "RGB", value: rgbValue)
                ColorInfoRow(label: "HSL", value: hslValue)
            }
            .padding(.horizontal)
            
            Button(action: startColorPicking) {
                Label("Pick Color", systemImage: "eyedropper")
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(PlainButtonStyle()) // This removes the default button styling
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)        }
        .frame(width: 300)
    }
    
    func startColorPicking() {
        isPicking = true
        
        // Hide the app temporarily
        if let window = NSApplication.shared.windows.first {
            window.orderOut(nil)
        }
        
        // Small delay to ensure the window is hidden
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let colorSampler = NSColorSampler()
            colorSampler.show { color in
                // Show the app again
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                }
                
                isPicking = false
                
                guard let color = color else { return }
                selectedColor = color
                
                // Update color values
                updateColorValues(color: color)
            }
        }
    }
    
    func updateColorValues(color: NSColor) {
        let rgbColor = color.usingColorSpace(.sRGB)!
        
        // HEX value
        hexValue = String(format: "#%02X%02X%02X", 
                         Int(rgbColor.redComponent * 255),
                         Int(rgbColor.greenComponent * 255),
                         Int(rgbColor.blueComponent * 255))
        
        // RGB value
        rgbValue = String(format: "%d, %d, %d",
                         Int(rgbColor.redComponent * 255),
                         Int(rgbColor.greenComponent * 255),
                         Int(rgbColor.blueComponent * 255))
        
        // HSL value
        let hslColor = rgbToHsl(r: rgbColor.redComponent, 
                               g: rgbColor.greenComponent, 
                               b: rgbColor.blueComponent)
        hslValue = String(format: "%d°, %d%%, %d%%", 
                         Int(hslColor.h * 360),
                         Int(hslColor.s * 100),
                         Int(hslColor.l * 100))
        
        // Find nearest Tailwind color
        tailwindColor = findNearestTailwindColor(color: rgbColor)
    }
    
    func rgbToHsl(r: CGFloat, g: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, l: CGFloat) {
        let max = max(r, max(g, b))
        let min = min(r, min(g, b))
        
        var h, s: CGFloat
        let l = (max + min) / 2
        
        if max == min {
            h = 0
            s = 0
        } else {
            let d = max - min
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
            
            if max == r {
                h = (g - b) / d + (g < b ? 6 : 0)
            } else if max == g {
                h = (b - r) / d + 2
            } else {
                h = (r - g) / d + 4
            }
            
            h /= 6
        }
        
        return (h, s, l)
    }
    
    func findNearestTailwindColor(color: NSColor) -> String {
        // Define Tailwind colors with their RGB values
        let tailwindColors: [(name: String, r: CGFloat, g: CGFloat, b: CGFloat)] = [
            // Slate
            ("slate-50", 248/255, 250/255, 252/255),
            ("slate-100", 241/255, 245/255, 249/255),
            ("slate-200", 226/255, 232/255, 240/255),
            ("slate-300", 203/255, 213/255, 225/255),
            ("slate-400", 148/255, 163/255, 184/255),
            ("slate-500", 100/255, 116/255, 139/255),
            ("slate-600", 71/255, 85/255, 105/255),
            ("slate-700", 51/255, 65/255, 85/255),
            ("slate-800", 30/255, 41/255, 59/255),
            ("slate-900", 15/255, 23/255, 42/255),
            ("slate-950", 2/255, 6/255, 23/255),
            
            // Gray
            ("gray-50", 249/255, 250/255, 251/255),
            ("gray-100", 243/255, 244/255, 246/255),
            ("gray-200", 229/255, 231/255, 235/255),
            ("gray-300", 209/255, 213/255, 219/255),
            ("gray-400", 156/255, 163/255, 175/255),
            ("gray-500", 107/255, 114/255, 128/255),
            ("gray-600", 75/255, 85/255, 99/255),
            ("gray-700", 55/255, 65/255, 81/255),
            ("gray-800", 31/255, 41/255, 55/255),
            ("gray-900", 17/255, 24/255, 39/255),
            ("gray-950", 3/255, 7/255, 18/255),
            
            // Zinc
            ("zinc-50", 250/255, 250/255, 250/255),
            ("zinc-100", 244/255, 244/255, 245/255),
            ("zinc-200", 228/255, 228/255, 231/255),
            ("zinc-300", 212/255, 212/255, 216/255),
            ("zinc-400", 161/255, 161/255, 170/255),
            ("zinc-500", 113/255, 113/255, 122/255),
            ("zinc-600", 82/255, 82/255, 91/255),
            ("zinc-700", 63/255, 63/255, 70/255),
            ("zinc-800", 39/255, 39/255, 42/255),
            ("zinc-900", 24/255, 24/255, 27/255),
            ("zinc-950", 9/255, 9/255, 11/255),
            
            // Neutral
            ("neutral-50", 250/255, 250/255, 250/255),
            ("neutral-100", 245/255, 245/255, 245/255),
            ("neutral-200", 229/255, 229/255, 229/255),
            ("neutral-300", 212/255, 212/255, 212/255),
            ("neutral-400", 163/255, 163/255, 163/255),
            ("neutral-500", 115/255, 115/255, 115/255),
            ("neutral-600", 82/255, 82/255, 82/255),
            ("neutral-700", 64/255, 64/255, 64/255),
            ("neutral-800", 38/255, 38/255, 38/255),
            ("neutral-900", 23/255, 23/255, 23/255),
            ("neutral-950", 10/255, 10/255, 10/255),
            
            // Stone
            ("stone-50", 250/255, 250/255, 249/255),
            ("stone-100", 245/255, 245/255, 244/255),
            ("stone-200", 231/255, 229/255, 228/255),
            ("stone-300", 214/255, 211/255, 209/255),
            ("stone-400", 168/255, 162/255, 158/255),
            ("stone-500", 120/255, 113/255, 108/255),
            ("stone-600", 87/255, 83/255, 78/255),
            ("stone-700", 68/255, 64/255, 60/255),
            ("stone-800", 41/255, 37/255, 36/255),
            ("stone-900", 28/255, 25/255, 23/255),
            ("stone-950", 12/255, 10/255, 9/255),
            
            // Red
            ("red-50", 254/255, 242/255, 242/255),
            ("red-100", 254/255, 226/255, 226/255),
            ("red-200", 254/255, 202/255, 202/255),
            ("red-300", 252/255, 165/255, 165/255),
            ("red-400", 248/255, 113/255, 113/255),
            ("red-500", 239/255, 68/255, 68/255),
            ("red-600", 220/255, 38/255, 38/255),
            ("red-700", 185/255, 28/255, 28/255),
            ("red-800", 153/255, 27/255, 27/255),
            ("red-900", 127/255, 29/255, 29/255),
            ("red-950", 69/255, 10/255, 10/255),
            
            // Orange
            ("orange-50", 255/255, 247/255, 237/255),
            ("orange-100", 255/255, 237/255, 213/255),
            ("orange-200", 254/255, 215/255, 170/255),
            ("orange-300", 253/255, 186/255, 116/255),
            ("orange-400", 251/255, 146/255, 60/255),
            ("orange-500", 249/255, 115/255, 22/255),
            ("orange-600", 234/255, 88/255, 12/255),
            ("orange-700", 194/255, 65/255, 12/255),
            ("orange-800", 154/255, 52/255, 18/255),
            ("orange-900", 124/255, 45/255, 18/255),
            ("orange-950", 67/255, 20/255, 7/255),
            
            // Amber
            ("amber-50", 255/255, 251/255, 235/255),
            ("amber-100", 254/255, 243/255, 199/255),
            ("amber-200", 253/255, 230/255, 138/255),
            ("amber-300", 252/255, 211/255, 77/255),
            ("amber-400", 251/255, 191/255, 36/255),
            ("amber-500", 245/255, 158/255, 11/255),
            ("amber-600", 217/255, 119/255, 6/255),
            ("amber-700", 180/255, 83/255, 9/255),
            ("amber-800", 146/255, 64/255, 14/255),
            ("amber-900", 120/255, 53/255, 15/255),
            ("amber-950", 69/255, 26/255, 3/255),
            
            // Yellow
            ("yellow-50", 254/255, 252/255, 232/255),
            ("yellow-100", 254/255, 249/255, 195/255),
            ("yellow-200", 254/255, 240/255, 138/255),
            ("yellow-300", 253/255, 224/255, 71/255),
            ("yellow-400", 250/255, 204/255, 21/255),
            ("yellow-500", 234/255, 179/255, 8/255),
            ("yellow-600", 202/255, 138/255, 4/255),
            ("yellow-700", 161/255, 98/255, 7/255),
            ("yellow-800", 133/255, 77/255, 14/255),
            ("yellow-900", 113/255, 63/255, 18/255),
            ("yellow-950", 66/255, 32/255, 6/255),
            
            // Lime
            ("lime-50", 247/255, 254/255, 231/255),
            ("lime-100", 236/255, 252/255, 203/255),
            ("lime-200", 217/255, 249/255, 157/255),
            ("lime-300", 190/255, 242/255, 100/255),
            ("lime-400", 163/255, 230/255, 53/255),
            ("lime-500", 132/255, 204/255, 22/255),
            ("lime-600", 101/255, 163/255, 13/255),
            ("lime-700", 77/255, 124/255, 15/255),
            ("lime-800", 63/255, 98/255, 18/255),
            ("lime-900", 54/255, 83/255, 20/255),
            ("lime-950", 26/255, 46/255, 5/255),
            
            // Green
            ("green-50", 240/255, 253/255, 244/255),
            ("green-100", 220/255, 252/255, 231/255),
            ("green-200", 187/255, 247/255, 208/255),
            ("green-300", 134/255, 239/255, 172/255),
            ("green-400", 74/255, 222/255, 128/255),
            ("green-500", 34/255, 197/255, 94/255),
            ("green-600", 22/255, 163/255, 74/255),
            ("green-700", 21/255, 128/255, 61/255),
            ("green-800", 22/255, 101/255, 52/255),
            ("green-900", 20/255, 83/255, 45/255),
            ("green-950", 5/255, 46/255, 22/255),
            
            // Emerald
            ("emerald-50", 236/255, 253/255, 245/255),
            ("emerald-100", 209/255, 250/255, 229/255),
            ("emerald-200", 167/255, 243/255, 208/255),
            ("emerald-300", 110/255, 231/255, 183/255),
            ("emerald-400", 52/255, 211/255, 153/255),
            ("emerald-500", 16/255, 185/255, 129/255),
            ("emerald-600", 5/255, 150/255, 105/255),
            ("emerald-700", 4/255, 120/255, 87/255),
            ("emerald-800", 6/255, 95/255, 70/255),
            ("emerald-900", 6/255, 78/255, 59/255),
            ("emerald-950", 2/255, 44/255, 34/255),
            
            // Teal
            ("teal-50", 240/255, 253/255, 250/255),
            ("teal-100", 204/255, 251/255, 241/255),
            ("teal-200", 153/255, 246/255, 228/255),
            ("teal-300", 94/255, 234/255, 212/255),
            ("teal-400", 45/255, 212/255, 191/255),
            ("teal-500", 20/255, 184/255, 166/255),
            ("teal-600", 13/255, 148/255, 136/255),
            ("teal-700", 15/255, 118/255, 110/255),
            ("teal-800", 17/255, 94/255, 89/255),
            ("teal-900", 19/255, 78/255, 74/255),
            ("teal-950", 4/255, 47/255, 46/255),
            
            // Cyan
            ("cyan-50", 236/255, 254/255, 255/255),
            ("cyan-100", 207/255, 250/255, 254/255),
            ("cyan-200", 165/255, 243/255, 252/255),
            ("cyan-300", 103/255, 232/255, 249/255),
            ("cyan-400", 34/255, 211/255, 238/255),
            ("cyan-500", 6/255, 182/255, 212/255),
            ("cyan-600", 8/255, 145/255, 178/255),
            ("cyan-700", 14/255, 116/255, 144/255),
            ("cyan-800", 21/255, 94/255, 117/255),
            ("cyan-900", 22/255, 78/255, 99/255),
            ("cyan-950", 8/255, 51/255, 68/255),
            
            // Sky
            ("sky-50", 240/255, 249/255, 255/255),
            ("sky-100", 224/255, 242/255, 254/255),
            ("sky-200", 186/255, 230/255, 253/255),
            ("sky-300", 125/255, 211/255, 252/255),
            ("sky-400", 56/255, 189/255, 248/255),
            ("sky-500", 14/255, 165/255, 233/255),
            ("sky-600", 2/255, 132/255, 199/255),
            ("sky-700", 3/255, 105/255, 161/255),
            ("sky-800", 7/255, 89/255, 133/255),
            ("sky-900", 12/255, 74/255, 110/255),
            ("sky-950", 8/255, 47/255, 73/255),
            
            // Blue
            ("blue-50", 239/255, 246/255, 255/255),
            ("blue-100", 219/255, 234/255, 254/255),
            ("blue-200", 191/255, 219/255, 254/255),
            ("blue-300", 147/255, 197/255, 253/255),
            ("blue-400", 96/255, 165/255, 250/255),
            ("blue-500", 59/255, 130/255, 246/255),
            ("blue-600", 37/255, 99/255, 235/255),
            ("blue-700", 29/255, 78/255, 216/255),
            ("blue-800", 30/255, 64/255, 175/255),
            ("blue-900", 30/255, 58/255, 138/255),
            ("blue-950", 23/255, 37/255, 84/255),
            
            // Indigo
            ("indigo-50", 238/255, 242/255, 255/255),
            ("indigo-100", 224/255, 231/255, 255/255),
            ("indigo-200", 199/255, 210/255, 254/255),
            ("indigo-300", 165/255, 180/255, 252/255),
            ("indigo-400", 129/255, 140/255, 248/255),
            ("indigo-500", 99/255, 102/255, 241/255),
            ("indigo-600", 79/255, 70/255, 229/255),
            ("indigo-700", 67/255, 56/255, 202/255),
            ("indigo-800", 55/255, 48/255, 163/255),
            ("indigo-900", 49/255, 46/255, 129/255),
            ("indigo-950", 30/255, 27/255, 75/255),
            
            // Violet
            ("violet-50", 245/255, 243/255, 255/255),
            ("violet-100", 237/255, 233/255, 254/255),
            ("violet-200", 221/255, 214/255, 254/255),
            ("violet-300", 196/255, 181/255, 253/255),
            ("violet-400", 167/255, 139/255, 250/255),
            ("violet-500", 139/255, 92/255, 246/255),
            ("violet-600", 124/255, 58/255, 237/255),
            ("violet-700", 109/255, 40/255, 217/255),
            ("violet-800", 91/255, 33/255, 182/255),
            ("violet-900", 76/255, 29/255, 149/255),
            ("violet-950", 46/255, 16/255, 101/255),
            
            // Purple
            ("purple-50", 250/255, 245/255, 255/255),
            ("purple-100", 243/255, 232/255, 255/255),
            ("purple-200", 233/255, 213/255, 255/255),
            ("purple-300", 216/255, 180/255, 254/255),
            ("purple-400", 192/255, 132/255, 252/255),
            ("purple-500", 168/255, 85/255, 247/255),
            ("purple-600", 147/255, 51/255, 234/255),
            ("purple-700", 126/255, 34/255, 206/255),
            ("purple-800", 107/255, 33/255, 168/255),
            ("purple-900", 88/255, 28/255, 135/255),
            ("purple-950", 59/255, 7/255, 100/255),
            
            // Fuchsia
            ("fuchsia-50", 253/255, 244/255, 255/255),
            ("fuchsia-100", 250/255, 232/255, 255/255),
            ("fuchsia-200", 245/255, 208/255, 254/255),
            ("fuchsia-300", 240/255, 171/255, 252/255),
            ("fuchsia-400", 232/255, 121/255, 249/255),
            ("fuchsia-500", 217/255, 70/255, 239/255),
            ("fuchsia-600", 192/255, 38/255, 211/255),
            ("fuchsia-700", 162/255, 28/255, 175/255),
            ("fuchsia-800", 134/255, 25/255, 143/255),
            ("fuchsia-900", 112/255, 26/255, 117/255),
            ("fuchsia-950", 74/255, 4/255, 78/255),
            
            // Pink
            ("pink-50", 253/255, 242/255, 248/255),
            ("pink-100", 252/255, 231/255, 243/255),
            ("pink-200", 251/255, 207/255, 232/255),
            ("pink-300", 249/255, 168/255, 212/255),
            ("pink-400", 244/255, 114/255, 182/255),
            ("pink-500", 236/255, 72/255, 153/255),
            ("pink-600", 219/255, 39/255, 119/255),
            ("pink-700", 190/255, 24/255, 93/255),
            ("pink-800", 157/255, 23/255, 77/255),
            ("pink-900", 131/255, 24/255, 67/255),
            ("pink-950", 80/255, 7/255, 36/255),
            
            // Rose
            ("rose-50", 255/255, 241/255, 242/255),
            ("rose-100", 255/255, 228/255, 230/255),
            ("rose-200", 254/255, 205/255, 211/255),
            ("rose-300", 253/255, 164/255, 175/255),
            ("rose-400", 251/255, 113/255, 133/255),
            ("rose-500", 244/255, 63/255, 94/255),
            ("rose-600", 225/255, 29/255, 72/255),
            ("rose-700", 190/255, 18/255, 60/255),
            ("rose-800", 159/255, 18/255, 57/255),
            ("rose-900", 136/255, 19/255, 55/255),
            ("rose-950", 76/255, 5/255, 25/255),
        ]
        
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestColor = "None"
        
        for tailwindColor in tailwindColors {
            let distance = pow(color.redComponent - tailwindColor.r, 2) +
                          pow(color.greenComponent - tailwindColor.g, 2) +
                          pow(color.blueComponent - tailwindColor.b, 2)
            
            if distance < minDistance {
                minDistance = distance
                closestColor = tailwindColor.name
            }
        }
        
        return closestColor
    }
}

extension Color {
    // Create a SwiftUI Color from NSColor (macOS 10.15+ compatible)
    static func fromNSColor(_ nsColor: NSColor) -> Color {
        let ciColor = CIColor(color: nsColor)!
        return Color(
            red: Double(ciColor.red),
            green: Double(ciColor.green),
            blue: Double(ciColor.blue),
            opacity: Double(ciColor.alpha)
        )
    }
}

// Then you would use it like this:
struct ColorPreview: View {
    let color: NSColor
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.fromNSColor(color))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

struct ColorInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 70, alignment: .leading)
                .foregroundColor(.secondary)
            
            Text(value)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(value, forType: .string)
            }) {
                Image(systemName: "doc.on.doc")
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
    }
}
