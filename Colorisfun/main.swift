import Cocoa
import StoreKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

let _ = StoreManager.shared

// Hide dock icon
NSApp.setActivationPolicy(.accessory)

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
