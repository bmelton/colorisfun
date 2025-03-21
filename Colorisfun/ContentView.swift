import SwiftUI
import Cocoa

extension NSColorSampler {
    static func pickColor(completion: @escaping (NSColor?) -> Void) {
        // Get reference to the window we want to hide
        var windowToRestore: NSWindow?
        if let window = NSApplication.shared.windows.first {
            windowToRestore = window
            // Hide the window before starting the color picker
            window.orderOut(nil)
        }
        
        // Create a new background thread to handle color picking
        DispatchQueue.global(qos: .userInitiated).async {
            let sampler = NSColorSampler()
            
            // Call back to the main thread when color is picked
            sampler.show { color in
                DispatchQueue.main.async {
                    // Restore the window
                    if let window = windowToRestore {
                        window.makeKeyAndOrderFront(nil)
                    }
                    
                    completion(color)
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var selectedColor: NSColor = .clear
    @State private var hexValue: String = "#000000"
    @State private var rgbValue: String = "0, 0, 0"
    @State private var hslValue: String = "0°, 0%, 0%"
    @State private var tailwindColor: String = "None"
    @State private var showPopoverTemporarily: Bool = false
    @State private var copyFeedbackVisible: Bool = false
    @State private var copiedFormat: String = ""
  
    // Create a state object for the manager
    @StateObject private var colorPickerManager: ColorPickerManager
    
    @ObservedObject private var copyBufferViewModel: CopyBufferViewModel
    
    var popover: NSPopover
    var statusBarItem: NSStatusItem

    init(appDelegate: AppDelegate, popover: NSPopover, statusBarItem: NSStatusItem) {
        self.copyBufferViewModel = CopyBufferViewModel(appDelegate: appDelegate)
        self.popover = popover
        self.statusBarItem = statusBarItem
        
        // Initialize the StateObject using _StateObject syntax
        _colorPickerManager = StateObject(wrappedValue: ColorPickerManager(popover: popover, statusBarItem: statusBarItem))
    }

    var body: some View {
        ZStack {
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
                    Label("Pick Color", image: "starlogo-white") // Replace systemImage
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            // Toast notification for automatic copy
            if copyFeedbackVisible {
                VStack {
                    Text("\(copiedFormat) copied to clipboard")
                        .font(.footnote)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 10)
                }
            }
        }
        .frame(width: 300)
        .onChange(of: showPopoverTemporarily, perform: { shouldShow in
            if shouldShow {
                if let button = statusBarItem.button {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showPopoverTemporarily = false
                    popover.performClose(nil)
                }
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ColorValueCopied"))) { notification in
            if let format = notification.userInfo?["format"] as? String {
                copiedFormat = format
                
                // Show toast notification
                withAnimation {
                    copyFeedbackVisible = true
                }
                
                // Hide after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        copyFeedbackVisible = false
                    }
                }
            }
        }
    }

    /*
    func startColorPicking() {
        isPicking = true
        
        if let window = NSApplication.shared.windows.first {
            // Move the window off-screen
            let originalFrame = window.frame
            window.setFrameOrigin(NSPoint(x: -window.frame.width, y: -window.frame.height))
            window.orderOut(nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let colorSampler = NSColorSampler()
                colorSampler.show { color in
                    if let window = NSApplication.shared.windows.first {
                        // Move the window back to its original position
                        window.setFrame(originalFrame, display: true)
                        window.makeKeyAndOrderFront(nil)
                    }

                    isPicking = false

                    guard let color = color else { return }
                    selectedColor = color

                    updateColorValues(color: color)
                    copyToBufferIfEnabled()
                    showPopoverTemporarily = true
                }
            }
        }
    }
    */
    
    // In your ContentView struct:
    func startColorPicking() {
        // Use the manager to handle everything
        colorPickerManager.pickColor { newColor in
            // This is a non-mutating callback that receives the color
            selectedColor = newColor
            updateColorValues(color: newColor)
            copyToBufferIfEnabled()
            showPopoverTemporarily = true
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
    
    func copyToBufferIfEnabled() {
        if copyBufferViewModel.getInjectToCopyBuffer() {
            let format = copyBufferViewModel.getCopyBufferFormat()
            var valueToCopy: String = ""

            switch format {
            case "Tailwind":
                valueToCopy = tailwindColor
            case "Hex":
                valueToCopy = hexValue
            case "RGB":
                valueToCopy = rgbValue
            case "HSL":
                valueToCopy = hslValue
            default:
                valueToCopy = hexValue // Default to Hex if format is unknown
            }
            copyBufferViewModel.copyToClipboard(value: valueToCopy)
            
            // Post notification for copy event
            NotificationCenter.default.post(
                name: Notification.Name("ColorValueCopied"),
                object: nil,
                userInfo: ["format": format]
            )
        }
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
    @State private var showCopiedFeedback = false
    
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
                
                // Post notification for copy event
                NotificationCenter.default.post(
                    name: Notification.Name("ColorValueCopied"),
                    object: nil,
                    userInfo: ["format": label]
                )
                
                // Show feedback
                withAnimation {
                    showCopiedFeedback = true
                }
                
                // Hide feedback after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showCopiedFeedback = false
                    }
                }
            }) {
                Group {
                    if showCopiedFeedback {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .transition(.opacity)
                    } else {
                        Image(systemName: "doc.on.doc")
                    }
                }
                .font(.caption)
            }
            .buttonStyle(.plain)
        }
    }
    
}

