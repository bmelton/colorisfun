import SwiftUI

struct ContentView: View {
    @State private var selectedColor: NSColor = .clear
    @State private var hexValue: String = "#000000"
    @State private var rgbValue: String = "0, 0, 0"
    @State private var hslValue: String = "0°, 0%, 0%"
    @State private var tailwindColor: String = "None"
    @State private var isPicking: Bool = false
    
    @ObservedObject private var copyBufferViewModel: CopyBufferViewModel
    
    init(appDelegate: AppDelegate) {
        self.copyBufferViewModel = CopyBufferViewModel(appDelegate: appDelegate)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Color is fun")
                .font(.headline)
                .padding(.top)
            
            ColorPreview(color: selectedColor)
                .frame(height: 80)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                ColorInfoRow(label: "Tailwind", value: tailwindColor, copyBufferViewModel: copyBufferViewModel)
                ColorInfoRow(label: "HEX", value: hexValue, copyBufferViewModel: copyBufferViewModel)
                ColorInfoRow(label: "RGB", value: rgbValue, copyBufferViewModel: copyBufferViewModel)
                ColorInfoRow(label: "HSL", value: hslValue, copyBufferViewModel: copyBufferViewModel)
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
        
        // TODO: At some point these should all share a struct
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
        
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestColor = "None"
        
        for tailwindColor in TailwindColors.allColors {
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

class CopyBufferViewModel: ObservableObject {
    private var appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func copyToClipboard(value: String) {
        if appDelegate.getInjectToCopyBuffer() {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(value, forType: .string)
        }
    }
    
    func getCopyBufferFormat() -> String {
        return appDelegate.getCopyBufferFormat()
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
    @ObservedObject var copyBufferViewModel: CopyBufferViewModel
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 70, alignment: .leading)
                .foregroundColor(.secondary)
            
            Text(value)
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: {
                if (copyBufferViewModel.getCopyBufferFormat().lowercased() == label.lowercased()) {
                    copyBufferViewModel.copyToClipboard(value: value)
                }
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
