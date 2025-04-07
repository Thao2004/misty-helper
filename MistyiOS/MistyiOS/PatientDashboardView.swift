//
//  PatientDashboardView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientDashboardView: View {
    @StateObject private var viewModel = PatientDashboardViewModel()
    let userId: Int

    var body: some View {
        ZStack {
            // Misty Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 350
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Top Greeting
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome Back!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text(viewModel.fullName.isEmpty ? "Loading..." : viewModel.fullName)
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.85))
                    }

                    Spacer()

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(getInitials())
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                }
                .padding(.horizontal)
                .padding(.top, 40)

                // Main Dashboard
                VStack(spacing: 16) {
                    VStack(spacing: 14) {
                        NavigationLink(destination: CheckupHistoryView(patientName: viewModel.fullName, patientId: userId)) {
                            PatientDashboardButton(title: "Checkup History", imageName: "waveform.path.ecg")
                        }
                        
                        NavigationLink(destination: ConnectToMistyView()) {
                            PatientDashboardButton(title: "Connect to Misty", imageName: "hare")
                        }
        
                        
                        if let userId = viewModel.userId {
                            NavigationLink(destination: MedicationListView(patientName: viewModel.fullName, patientId: userId)) {
                                PatientDashboardButton(title: "Medication List", imageName: "pills.fill")
                            }
                        }
                        
                        
                        NavigationLink(destination: ScheduledCheckupListView(patientId: userId)) {
                            PatientDashboardButton(title: "Upcoming Scheduled Checkups", imageName: "calendar.badge.clock")
                            
                        }
                    }
                
                }
                .padding(.horizontal)

                Spacer()

                // Tab Bar (Styled)
                HStack {
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))

                    Spacer()

                    Button(action: {
                        // SOS Action
                    }) {
                        Text("SOS")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }

                    Spacer()

                    NavigationLink(destination: PatientProfileView(viewModel: viewModel)) {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.9))
                    }

                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
            .onAppear {
                viewModel.fetchPatientInfo(userId: userId)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func getInitials() -> String {
        let parts = viewModel.fullName.split(separator: " ")
        return parts.prefix(2).map { String($0.prefix(1)) }.joined()
    }
}

struct PatientDashboardButton: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 45)
                .foregroundColor(Color(red: 0.27, green: 0.51, blue: 0.79))

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

