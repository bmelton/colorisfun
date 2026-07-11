import SwiftUI
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var statusMenu: NSMenu!
    
    @AppStorage("injectToCopyBuffer") private var injectToCopyBuffer: Bool = false
    @AppStorage("copyBufferFormat") private var copyBufferFormat: String = "Tailwind"

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize StoreManager
        let _ = StoreManager.shared
        
        // Check trial status first
        checkTrialStatus()
        
        // Continue with regular setup
        setupStatusBarItem()
        setupPopover()
        setupStatusMenu()
    }

    
    func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        NSApplication.shared.setActivationPolicy(.accessory)

        if let button = statusBarItem.button {
            if let image = NSImage(named: "starlogo-pink") { // Load your custom image
                image.size = NSSize(width: 18, height: 18) // Adjust size as needed
                image.isTemplate = true
                button.image = image
            } else {
                print("Error: Failed to load starlogo-pink image.")
                button.image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "Color is fun")//fallback to eyedropper if image fails to load.
            }

            button.target = self
            button.action = #selector(statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    func checkTrialStatus() {
        // Check if app is in valid trial or purchased state
        if !TrialManager.shared.isAppUnlocked {
            // Trial expired and not purchased
            disableAppFunctionality()
            
            // Show an alert when app launches
            let alert = NSAlert()
            alert.messageText = "Trial Period Expired"
            alert.informativeText = "Your 7-day trial of Color is fun has ended. Purchase the full version to continue using all features."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Purchase Now")
            alert.addButton(withTitle: "Quit")
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                // User clicked Purchase Now
                purchaseFullVersion()
            } else {
                // User clicked Quit
                NSApplication.shared.terminate(nil)
            }
        } else if TrialManager.shared.isTrialValid {
            // In trial mode - show notification
            let daysLeft = TrialManager.shared.daysRemaining
            StoreManager.shared.showNotification(title: "Color is fun - Trial Mode",
                                                 body: "You have \(daysLeft) days remaining in your trial.")
        }
        
        // Setup notification observer for purchase completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(purchaseCompleted),
            name: Notification.Name("PurchaseCompleted"),
            object: nil
        )
    }

    func disableAppFunctionality() {
        // If user can still access menu bar, disable key features
        injectToCopyBuffer = false
    }

    // Rebuild menu to show purchased status (StoreManager already notifies the user)
    @objc func purchaseCompleted() {
        setupStatusMenu()
    }

    // Tag identifying the trial/purchase header items so menuWillOpen can replace them
    private static let trialItemTag = 999

    // Builds the trial/purchase status items (plus trailing separator) for the top of the menu
    private func trialStatusItems() -> [NSMenuItem] {
        var items: [NSMenuItem] = []

        if TrialManager.shared.isTrialValid {
            let trialItem = NSMenuItem(title: "Trial: \(TrialManager.shared.daysRemaining) days remaining", action: nil, keyEquivalent: "")
            trialItem.isEnabled = false
            items.append(trialItem)

            items.append(NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: ""))
        } else if UserDefaults.standard.bool(forKey: "hasPurchased") {
            let purchasedItem = NSMenuItem(title: "✓ Full Version", action: nil, keyEquivalent: "")
            purchasedItem.isEnabled = false
            items.append(purchasedItem)
        } else {
            let expiredItem = NSMenuItem(title: "Trial Expired", action: nil, keyEquivalent: "")
            expiredItem.isEnabled = false
            items.append(expiredItem)

            let purchaseItem = NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: "")
            purchaseItem.attributedTitle = NSAttributedString(string: "Purchase Full Version",
                                                           attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 13)])
            items.append(purchaseItem)
        }

        items.append(NSMenuItem.separator())
        items.forEach { $0.tag = Self.trialItemTag }
        return items
    }

    func menuWillOpen(_ menu: NSMenu) {
        // Replace the trial/purchase header with current status
        while let first = statusMenu.items.first, first.tag == Self.trialItemTag {
            statusMenu.removeItem(first)
        }
        for (index, item) in trialStatusItems().enumerated() {
            statusMenu.insertItem(item, at: index)
        }

        updateMenuState()
    }


    func setupStatusMenu() {
        statusMenu = NSMenu(title: "Colorisfun Menu")
        statusMenu.delegate = self
        // Trial/purchase header is added by menuWillOpen just before display

        let injectItem = NSMenuItem(title: "Inject selection to copy buffer", action: #selector(toggleInjectToCopyBuffer), keyEquivalent: "")
        injectItem.state = injectToCopyBuffer ? .on : .off
        statusMenu.addItem(injectItem)
        
        let formatItem = NSMenuItem(title: "Copy Buffer Format", action: nil, keyEquivalent: "")
         let formatMenu = NSMenu(title: "Copy Buffer Format")
 
         let tailwindItem = NSMenuItem(title: "Tailwind", action: #selector(selectCopyBufferFormat), keyEquivalent: "")
         tailwindItem.representedObject = "Tailwind"
         formatMenu.addItem(tailwindItem)
 
         let hexItem = NSMenuItem(title: "Hex", action: #selector(selectCopyBufferFormat), keyEquivalent: "")
         hexItem.representedObject = "Hex"
         formatMenu.addItem(hexItem)
 
         let rgbItem = NSMenuItem(title: "RGB", action: #selector(selectCopyBufferFormat), keyEquivalent: "")
         rgbItem.representedObject = "RGB"
         formatMenu.addItem(rgbItem)
 
         let hslItem = NSMenuItem(title: "HSL", action: #selector(selectCopyBufferFormat), keyEquivalent: "")
         hslItem.representedObject = "HSL"
         formatMenu.addItem(hslItem)
 
         formatItem.submenu = formatMenu
         statusMenu.addItem(formatItem)

        statusMenu.addItem(NSMenuItem.separator())
        let restoreItem = NSMenuItem(title: "Restore Purchases", action: #selector(restorePurchases), keyEquivalent: "")
        statusMenu.addItem(restoreItem)
        
        let quitItem = NSMenuItem(title: "Quit Color is fun", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        statusMenu.addItem(quitItem)
        
        updateMenuState()
    }
    
    @objc func purchaseFullVersion() {
        StoreManager.shared.purchaseProduct()
    }

    @objc func restorePurchases() {
        StoreManager.shared.restorePurchases()
    }

    
    @objc func statusBarButtonClicked(sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            if let button = statusBarItem.button {
                let menuOrigin = CGPoint(x: button.bounds.minX, y: button.bounds.minY)
                statusMenu.popUp(positioning: nil, at: menuOrigin, in: button)
            }
        } else {
            togglePopover()
        }
    }

    func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.behavior = .transient
        // Now pass the popover
        // pass the statusbar item
        popover.contentViewController = NSHostingController(rootView: ContentView(appDelegate: self, popover: popover, statusBarItem: statusBarItem))
    }

    @objc func togglePopover() {
       
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
        
    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }

    @objc func toggleInjectToCopyBuffer() {
        injectToCopyBuffer.toggle()
        updateMenuState()
    }

    @objc func selectCopyBufferFormat(sender: NSMenuItem) {
        if let format = sender.representedObject as? String {
            copyBufferFormat = format
            updateMenuState()
        }
    }

    func updateMenuState() {
        // Find the "Inject selection to copy buffer" menu item
        if let injectItem = statusMenu.items.first(where: { $0.title == "Inject selection to copy buffer" }) {
            injectItem.state = injectToCopyBuffer ? .on : .off
        }
        
        // Find the "Copy Buffer Format" menu item
        if let formatItem = statusMenu.items.first(where: { $0.title == "Copy Buffer Format" }),
           let formatMenu = formatItem.submenu {
            
            formatItem.isEnabled = injectToCopyBuffer
            
            // Update checkmarks on format submenu items
            for item in formatMenu.items {
                if let format = item.representedObject as? String {
                    item.state = (format == copyBufferFormat) ? .on : .off
                    item.isEnabled = injectToCopyBuffer
                }
            }
        }
    }
    
    func getCopyBufferFormat() -> String {
        return copyBufferFormat
    }
    
    func getInjectToCopyBuffer() -> Bool {
        return injectToCopyBuffer
    }
}

