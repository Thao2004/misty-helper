//
//  PatientDashboardView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientDashboardView: View {
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
                    PatientDashboardButton(title: "Health report", imageName: "waveform.path.ecg")
                        .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: ConnectToMistyView()) {
                        PatientDashboardButton(title: "Connect to Misty", imageName: "hare")
                            .frame(maxWidth: .infinity)
                    }
                }

                // Actions - Set medication & To do list horizontally aligned
                HStack(spacing: 16) {
                    PatientDashboardButton(title: "Set medication", imageName: "pills")
                    NavigationLink(destination: ReminderView()) {
                        PatientDashboardButton(title: "Reminder List", imageName: "checklist")
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

struct PatientDashboardButton: View {
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


#Preview {
    PatientDashboardView()
}
