import SwiftUI
import Cocoa

class ColorPickerManager: ObservableObject {
    // Reference to the main UI elements
    weak var popover: NSPopover?
    weak var statusBarItem: NSStatusItem?
    
    // Published properties for SwiftUI to observe
    @Published var selectedColor: NSColor = .clear
    @Published var isPicking: Bool = false
    
    init(popover: NSPopover, statusBarItem: NSStatusItem) {
        self.popover = popover
        self.statusBarItem = statusBarItem
    }
    
    func pickColor(colorUpdateCallback: @escaping (NSColor) -> Void) {
        // Start picking
        isPicking = true
        
        // Close the popover if it's showing
        if let popover = self.popover, popover.isShown {
            popover.performClose(nil)
        }
        
        // Create the color sampler on a background thread to prevent UI disruption
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let sampler = NSColorSampler()
            
            // Run the color picker
            sampler.show { [weak self] color in
                // Return to the main thread
                DispatchQueue.main.async {
                    // Set picking to false
                    self?.isPicking = false
                    
                    // Process the selected color
                    if let color = color {
                        self?.selectedColor = color
                        colorUpdateCallback(color)
                    }
                }
            }
        }
    }
}
