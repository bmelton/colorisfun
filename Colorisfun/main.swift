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
