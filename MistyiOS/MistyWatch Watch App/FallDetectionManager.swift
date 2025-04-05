//
//  FallDetectionManager.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import WatchConnectivity
import CoreMotion
import SwiftUI

class FallDetectionManager: NSObject, WCSessionDelegate, ObservableObject {
    // @Published property to trigger the fall detection alert in the UI
    @Published var showFallAlert = false
    
    private let motionManager = CMMotionActivityManager()
    private let session = WCSession.default
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func startFallDetection() {
        // Start detecting fall using CoreMotion
        motionManager.startActivityUpdates(to: OperationQueue.main) { activity in
            // Safely unwrap the activity object
            guard let activity = activity else {
                return  // If activity is nil, return
            }

            // Check if the activity is stationary (as a simple fallback example)
            if activity.stationary {
                self.sendFallDetectedMessage()  // Send fall detection message
            }
        }
    }

    private func sendFallDetectedMessage() {
        if session.isReachable {
            session.sendMessage(["fallDetected": true], replyHandler: { response in
                // Handle success
                print("Fall detected message sent successfully")
            }, errorHandler: { error in
                // Handle error
                print("Error sending message: \(error.localizedDescription)")
            })
        } else {
            print("WCSession not reachable.")
        }
    }
    
    // Handle receiving the fall detection message from iOS
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let fallDetected = message["fallDetected"] as? Bool, fallDetected {
            DispatchQueue.main.async {
                self.showFallAlert = true  // Trigger the alert when fall is detected
            }
        }
    }

    // Handle session activation completion
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error activating WCSession: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully! State: \(activationState.rawValue)")
        }
    }
}






