import Foundation
import StoreKit

class TrialManager {
    
    // Keys for UserDefaults
    private let firstLaunchDateKey = "firstLaunchDate"
    private let hasPurchasedKey = "hasPurchased"
    
    // Singleton instance
    static let shared = TrialManager()
    
    private init() {
        // Check if it's the first launch ever and set the date
        checkAndSetFirstLaunchDate()
    }
    
    // Check if the app is in trial mode or has been purchased
    var isAppUnlocked: Bool {
        // If user has purchased, return true
        if UserDefaults.standard.bool(forKey: hasPurchasedKey) {
            return true
        }
        
        // Check if trial is still valid
        return isTrialValid
    }

    
    // Check if the trial period is still valid
    var isTrialValid: Bool {
        // return false
        guard let firstLaunchDate = UserDefaults.standard.object(forKey: firstLaunchDateKey) as? Date else {
            return false
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate days between first launch and now
        if let days = calendar.dateComponents([.day], from: firstLaunchDate, to: now).day {
            return days < 7
        }
        
        return false
    }
    
    // Returns days remaining in trial
    var daysRemaining: Int {
        guard let firstLaunchDate = UserDefaults.standard.object(forKey: firstLaunchDateKey) as? Date else {
            return 0
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        if let days = calendar.dateComponents([.day], from: firstLaunchDate, to: now).day {
            let remaining = 7 - days
            return remaining > 0 ? remaining : 0
        }
        
        return 0
    }
    
    // Set up first launch date if not already set
    private func checkAndSetFirstLaunchDate() {
        if UserDefaults.standard.object(forKey: firstLaunchDateKey) == nil {
            UserDefaults.standard.set(Date(), forKey: firstLaunchDateKey)
        }
    }
    
    // Mark the app as purchased
    func markAsPurchased() {
        UserDefaults.standard.set(true, forKey: hasPurchasedKey)
    }
    
    // For testing: Reset the trial period
    func resetTrial() {
        UserDefaults.standard.removeObject(forKey: firstLaunchDateKey)
        UserDefaults.standard.set(false, forKey: hasPurchasedKey)
        checkAndSetFirstLaunchDate()
    }
}
