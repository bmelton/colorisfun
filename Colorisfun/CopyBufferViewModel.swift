import SwiftUI
import Cocoa

class CopyBufferViewModel: ObservableObject {
    private var appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func copyToClipboard(value: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(value, forType: .string)
    }
    
    func getCopyBufferFormat() -> String {
        return appDelegate.getCopyBufferFormat()
    }
    
    func getInjectToCopyBuffer() -> Bool {
        return appDelegate.getInjectToCopyBuffer()
    }
}
