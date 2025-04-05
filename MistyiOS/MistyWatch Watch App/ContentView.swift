//
//  ContentView.swift
//  MistyWatch Watch App
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct ContentView: View {
    // Initialize FallDetectionManager as a @StateObject
    @StateObject private var fallDetectionManager = FallDetectionManager()

    var body: some View {
        VStack {
            Text("Misty WatchOS Fall Detection")
                .font(.title)
                .padding()

            // Button to start fall detection on the watch
            Button(action: {
                fallDetectionManager.startFallDetection() // Start fall detection on the watch
            }) {
                Text("Start Fall Detection")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            // If fall is detected, show an alert
            Spacer()
        }
        .padding()
        .alert(isPresented: $fallDetectionManager.showFallAlert) {
            Alert(title: Text("Fall Detected"), message: Text("A fall has been detected. Please check!"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}

