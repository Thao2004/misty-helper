//
//  WatchConnectivityManager.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import WatchConnectivity
import SwiftUI

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    
    // Published property to trigger the fall alert in the UI
    @Published var showFallAlert = false
    
    static let shared = WatchConnectivityManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // Handle session activation completion
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error activating WCSession: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully!")
        }
    }

    // Handle receiving the fall detection message from the watchOS app
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let fallDetected = message["fallDetected"] as? Bool, fallDetected {
            DispatchQueue.main.async {
                // Update the showFallAlert property to trigger the alert in HomeDashboardView
                self.showFallAlert = true
            }
        }
    }

    // MARK: - Required WCSessionDelegate Methods

    // This method is called when the session becomes inactive (e.g., app goes into background)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // You can add your handling code here if needed
        print("WCSession became inactive.")
    }

    // This method is called when the session is deactivated (e.g., app is terminated or the session is explicitly closed)
    func sessionDidDeactivate(_ session: WCSession) {
        // You can add your handling code here if needed
        print("WCSession deactivated.")
    }
}

