import Cocoa
import StoreKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

let _ = StoreManager.shared

// Hide dock icon
NSApp.setActivationPolicy(.accessory)

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

/*
import Cocoa

// Create the application instance
let app = NSApplication.shared

// Set the app delegate
let delegate = AppDelegate()
app.delegate = delegate

// Hide dock icon
NSApp.setActivationPolicy(.accessory)

// Start the main run loop
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

*/
