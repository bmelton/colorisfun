import SwiftUI
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var statusBarItem: NSStatusItem!
    var popover: NSPopover!
    var statusMenu: NSMenu!
    
    @AppStorage("injectToCopyBuffer") private var injectToCopyBuffer: Bool = false
    @AppStorage("copyBufferFormat") private var copyBufferFormat: String = "Tailwind"

    func applicationDidFinishLaunching(_ notification: Notification) {
        // We set the activation policy in main.swift, so we don't need it here

        setupStatusBarItem()
        setupPopover()
        setupStatusMenu()
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        updateMenuState()
    }

    func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusBarItem.button {
            button.image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "Color is fun")
            button.target = self
            button.action = #selector(statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
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
        popover.contentViewController = NSHostingController(rootView: ContentView(appDelegate: self))
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
    
    func setupStatusMenu() {
        statusMenu = NSMenu(title: "Colorisfun Menu")
        statusMenu.delegate = self

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

        updateMenuState()
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
        
        if let injectItem = statusMenu.items.first {
            injectItem.state = injectToCopyBuffer ? .on : .off
        }
        
        guard let formatItem = statusMenu.items.last, let formatMenu = formatItem.submenu else {
            return
        }
        
        //formatItem.isHidden = !injectToCopyBuffer  //Remove this line

        formatItem.isEnabled = injectToCopyBuffer // Add this line

        for item in formatMenu.items {
            if let format = item.representedObject as? String {
                item.state = (format == copyBufferFormat) ? .on : .off
                item.isEnabled = injectToCopyBuffer // Add this line
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
