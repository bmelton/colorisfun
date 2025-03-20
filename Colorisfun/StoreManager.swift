// StoreManager.swift with modern notification system

import Foundation
import StoreKit
import UserNotifications

class StoreManager: NSObject {
    static let shared = StoreManager()
    
    // Your product identifier from App Store Connect
    let productID = "com.sureisfun.colorisfun"
    
    override init() {
        super.init()
        // Set up payment queue observer
        SKPaymentQueue.default().add(self)
        
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    // Helper method to show notifications
    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // For development/testing only
    func forcePurchase() {
        TrialManager.shared.markAsPurchased()
        NotificationCenter.default.post(name: Notification.Name("PurchaseCompleted"), object: nil)
        showNotification(title: "Test Purchase Successful", body: "The app has been marked as purchased (test mode).")
    }
    
    func purchaseProduct() {
        // Show purchasing indicator
        showNotification(title: "Processing Purchase", body: "Connecting to the App Store...")
        
        // Request the product from the App Store
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        request.start()
    }
    
    // Handle purchase restoration
    func restorePurchases() {
        showNotification(title: "Restoring Purchases", body: "Checking for previous purchases...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // Handle the purchase completion
    func handlePurchaseCompletion(transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .purchased:
            // Product was purchased
            TrialManager.shared.markAsPurchased()
            SKPaymentQueue.default().finishTransaction(transaction)
            
            // Post notification so the app can update its UI
            NotificationCenter.default.post(name: Notification.Name("PurchaseCompleted"), object: nil)
            
            // Notify user
            showNotification(title: "Purchase Successful", body: "Thank you for purchasing Color is fun!")
            
        case .restored:
            // Purchase was restored
            TrialManager.shared.markAsPurchased()
            SKPaymentQueue.default().finishTransaction(transaction)
            
            // Notify user about restoration
            showNotification(title: "Purchase Restored", body: "Your previous purchase has been restored.")
            
            // Post notification so the app can update its UI
            NotificationCenter.default.post(name: Notification.Name("PurchaseCompleted"), object: nil)
            
        case .failed:
            // Purchase failed
            SKPaymentQueue.default().finishTransaction(transaction)
            
            // Notify user about failure
            let errorMessage = transaction.error?.localizedDescription ?? "Unknown error"
            showNotification(title: "Purchase Failed", body: "There was a problem with your purchase: \(errorMessage)")
            
        default:
            break
        }
    }
}

// StoreKit delegate methods
extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.isEmpty {
            // No products found
            showNotification(title: "Product Not Available", body: "The product could not be found in the App Store.")
            return
        }
        
        if let product = response.products.first {
            // Show confirmation with price
            let price = product.priceLocale.currencySymbol! + product.price.stringValue
            
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Purchase Full Version"
                alert.informativeText = "Would you like to purchase Color is fun for \(price)?"
                alert.alertStyle = .informational
                alert.addButton(withTitle: "Purchase")
                alert.addButton(withTitle: "Cancel")
                
                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    // User confirmed purchase
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                }
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        // Handle request error
        showNotification(title: "Connection Error", body: "Could not connect to the App Store: \(error.localizedDescription)")
    }
}

// Add an observer for payment queue
extension StoreManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            handlePurchaseCompletion(transaction: transaction)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // No purchases to restore
        if queue.transactions.isEmpty {
            showNotification(title: "No Purchases Found", body: "No previous purchases were found to restore.")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // Restoration failed
        showNotification(title: "Restore Failed", body: "Could not restore previous purchases: \(error.localizedDescription)")
    }
}
