import SwiftUI
import Cocoa
import StoreKit

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
            let notification = NSUserNotification()
            notification.title = "Color is fun - Trial Mode"
            notification.informativeText = "You have \(daysLeft) days remaining in your trial."
            NSUserNotificationCenter.default.deliver(notification)
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
        
        // If you have menu items that should be disabled, add:
        // let disabledItems = ["Item name 1", "Item name 2"]
        // for item in statusMenu?.items ?? [] {
        //     if disabledItems.contains(item.title) {
        //         item.isEnabled = false
        //     }
        // }
    }
    
    // Enable full functionality after purchase
    @objc func purchaseCompleted() {
        // Re-enable functionality
        enableFullFunctionality()
        
        // Notify user
        let notification = NSUserNotification()
        notification.title = "Purchase Successful"
        notification.informativeText = "Thank you for purchasing Color is fun! All features have been unlocked."
        NSUserNotificationCenter.default.deliver(notification)
        
        // Rebuild menu to show purchased status
        setupStatusMenu()
    }

    func enableFullFunctionality() {
        // Reset any disabled features here
        // Example: re-enable menu items that were disabled
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        // First remove any existing trial/purchase items (the first few items)
        while statusMenu.items.count > 0 &&
              (statusMenu.items[0].title.contains("Trial") ||
               statusMenu.items[0].title.contains("Purchase") ||
               statusMenu.items[0].title.contains("Full Version")) {
            statusMenu.removeItem(at: 0)
        }
        
        // Remove first separator if it exists
        if statusMenu.items.count > 0 && statusMenu.items[0].isSeparatorItem {
            statusMenu.removeItem(at: 0)
        }
        
        // Re-add the trial/purchase status items at the top
        if TrialManager.shared.isTrialValid {
            let daysLeft = TrialManager.shared.daysRemaining
            let trialItem = NSMenuItem(title: "Trial: \(daysLeft) days remaining", action: nil, keyEquivalent: "")
            trialItem.isEnabled = false
            statusMenu.insertItem(trialItem, at: 0)
            
            let purchaseItem = NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: "")
            statusMenu.insertItem(purchaseItem, at: 1)
        } else if UserDefaults.standard.bool(forKey: "hasPurchased") {
            let purchasedItem = NSMenuItem(title: "✓ Full Version", action: nil, keyEquivalent: "")
            purchasedItem.isEnabled = false
            statusMenu.insertItem(purchasedItem, at: 0)
        } else {
            let expiredItem = NSMenuItem(title: "Trial Expired", action: nil, keyEquivalent: "")
            expiredItem.isEnabled = false
            statusMenu.insertItem(expiredItem, at: 0)
            
            let purchaseItem = NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: "")
            purchaseItem.attributedTitle = NSAttributedString(string: "Purchase Full Version",
                                                           attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 13)])
            statusMenu.insertItem(purchaseItem, at: 1)
        }
        
        statusMenu.insertItem(NSMenuItem.separator(), at: 2)
        
        // Update other menu items state
        updateMenuState()
    }


    func setupStatusMenu() {
        statusMenu = NSMenu(title: "Colorisfun Menu")
        statusMenu.delegate = self
        
        // Add trial/purchase status at the top of menu
        if TrialManager.shared.isTrialValid {
            // Show trial status with days remaining
            let daysLeft = TrialManager.shared.daysRemaining
            let trialItem = NSMenuItem(title: "Trial: \(daysLeft) days remaining", action: nil, keyEquivalent: "")
            trialItem.isEnabled = false
            statusMenu.addItem(trialItem)
            
            // Add purchase option
            let purchaseItem = NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: "")
            statusMenu.addItem(purchaseItem)
        } else if UserDefaults.standard.bool(forKey: "hasPurchased") {
            // Show purchased status
            let purchasedItem = NSMenuItem(title: "✓ Full Version", action: nil, keyEquivalent: "")
            purchasedItem.isEnabled = false
            statusMenu.addItem(purchasedItem)
        } else {
            // Trial expired - show prominent purchase option
            let expiredItem = NSMenuItem(title: "Trial Expired", action: nil, keyEquivalent: "")
            expiredItem.isEnabled = false
            statusMenu.addItem(expiredItem)
            
            let purchaseItem = NSMenuItem(title: "Purchase Full Version", action: #selector(purchaseFullVersion), keyEquivalent: "")
            purchaseItem.attributedTitle = NSAttributedString(string: "Purchase Full Version",
                                                           attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 13)])
            statusMenu.addItem(purchaseItem)
        }
        
        statusMenu.addItem(NSMenuItem.separator())

        // Continue with your existing menu items...
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
 
         // Add the Quit menu item
         statusMenu.addItem(NSMenuItem.separator()) // Add a separator for better visual separation

        // Add restore purchases option before quit
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
        SKPaymentQueue.default().restoreCompletedTransactions()
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
