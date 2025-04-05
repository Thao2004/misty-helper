//
//  HomeDashboardView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct HomeDashboardView: View {
    @StateObject private var viewModel = HomeDashboardViewModel()

    var body: some View {
        VStack {
            // Top greeting
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome Back!")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Jonathan Patterson")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                // You can place a profile image or notification icon here
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Text("JP").foregroundColor(.white))
            }
            .padding()

            // Main Dashboard area
            // Health report & Connect to Misty full width buttons
            VStack(spacing: 16) {
                VStack {
                    DashboardButton(title: "Health report", imageName: "waveform.path.ecg")
                        .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: ConnectToMistyView()) {
                        DashboardButton(title: "Connect to Misty", imageName: "hare")
                            .frame(maxWidth: .infinity)
                    }

                    // Connect to Apple Watch
                    NavigationLink(destination: ConnectToAppleWatchView()) {
                        DashboardButton(title: "Connect to Apple Watch", imageName: "applewatch")
                            .frame(maxWidth: .infinity)
                    }
                }

                // Actions - Set medication & To do list horizontally aligned
                HStack(spacing: 16) {
                    DashboardButton(title: "Set medication", imageName: "pills")
                    NavigationLink(destination: ReminderView()) {
                        DashboardButton(title: "Reminder List", imageName: "checklist")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
            
            // Bottom SOS button and maybe a simple tab bar
            HStack {
                // Placeholder for a "Home" tab icon
                Button(action: {}) {
                    Image(systemName: "house.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // SOS Button
                Button(action: {
                    // SOS action here
                }) {
                    Text("SOS")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                // Placeholder for a "Profile" tab icon
                Button(action: {}) {
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }
}

struct DashboardButton: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            // Replace with your own images/icons later
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// A view to simulate the Apple Watch connection
struct ConnectToAppleWatchView: View {
    var body: some View {
        VStack {
            Text("Connect to Apple Watch")
                .font(.largeTitle)
                .padding()

            Text("Make sure your Apple Watch is turned on and in range.")
                .font(.body)
                .padding()

            // Simulate connecting button or instructions here
            Button(action: {
                // Add Apple Watch connection logic here
                print("Connecting to Apple Watch...")
            }) {
                Text("Connect")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationBarTitle("Apple Watch", displayMode: .inline)
        .padding()
    }
}


#Preview {
    HomeDashboardView()
}
