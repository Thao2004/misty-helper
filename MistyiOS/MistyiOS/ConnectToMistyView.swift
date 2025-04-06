//
//  ConnectToMistyView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct ConnectToMistyView: View {
    @State private var isConnected = false
    @State private var isLoading = false

    var body: some View {
        ZStack {
            // Misty background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 350
            ).ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Connect to Misty")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                // Status Text
                Text(isConnected ? "Misty is Connected" : "Misty Not Connected")
                    .font(.title2)
                    .foregroundColor(isConnected ? .green : .red)

                // Conditional content
                if isLoading {
                    ProgressView("Connecting...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.top, 20)
                } else if isConnected {
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 270, height: 270)
                            .shadow(color: Color.green.opacity(0.6), radius: 20)

                        Image("misty")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                    }
                }

                // Button
                Button(action: {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isConnected.toggle()
                        isLoading = false
                    }
                }) {
                    HStack {
                        Image(systemName: "wifi")
                        Text(isConnected ? "Disconnect from Misty" : "Connect to Misty")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isConnected ? Color.red : Color.blue)
                    .cornerRadius(14)
                }
                .padding(.horizontal)

                // Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Connection Instructions:")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("1. Make sure Misty is turned on")
                    Text("2. Keep Misty within 10 feet")
                    Text("3. Press the Connect button")
                    Text("4. Wait for the connection to complete")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

