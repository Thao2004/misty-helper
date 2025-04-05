//
//  ConnectToMistyView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct ConnectToMistyView: View {
    @State private var isConnected = false
    
    var body: some View {
        VStack {
            // Close Button
            HStack {
                Button("Close") {
                    // Action to close the view (e.g., pop view or navigate back)
                }
                .foregroundColor(.blue)
                Spacer()
            }
            .padding()

            // Title
            Text("Connect to Misty")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Status message: Misty not connected
            Text(isConnected ? "Misty is Connected" : "Misty Not Connected")
                .font(.title2)
                .foregroundColor(isConnected ? .green : .red)
                .padding(.top, 20)

            // Misty image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(Text("Misty Image Here").foregroundColor(.white))

            // Connect Button
            Button(action: {
                // Simulate connection action
                self.isConnected.toggle()
            }) {
                HStack {
                    Image(systemName: "wifi")
                    Text(isConnected ? "Disconnect from Misty" : "Connect to Misty")
                }
                .padding()
                .background(isConnected ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top, 20)
            }

            // Connection Instructions
            VStack(alignment: .leading, spacing: 10) {
                Text("Connection Instructions:")
                    .font(.headline)
                    .padding(.top, 20)

                Text("1. Make sure Misty is turned on")
                Text("2. Keep Misty within 10 feet")
                Text("3. Press the Connect button")
                Text("4. Wait for the connection to complete")
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ConnectToMistyView()
}
