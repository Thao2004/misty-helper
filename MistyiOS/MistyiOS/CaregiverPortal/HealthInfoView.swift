//
//  HealthInfoView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct HealthInfoView: View {
    let patientName: String
    @Environment(\.dismiss) private var dismiss

    // These will be loaded dynamically
    @State private var height: Double?
    @State private var weight: Double?
    @State private var bloodType: String?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Background
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

            VStack(spacing: 30) {
                // Custom Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .medium))
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Text(patientName)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)

                if isLoading {
                    ProgressView("Loading health info...")
                        .foregroundColor(.white)
                } else {
                    VStack(spacing: 16) {
                        if let height = height {
                            HealthInfoRow(label: "Height", value: "\(height) cm")
                        }
                        if let weight = weight {
                            HealthInfoRow(label: "Weight", value: "\(weight) kg")
                        }
                        if let bloodType = bloodType {
                            HealthInfoRow(label: "Blood Type", value: bloodType)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .onAppear {
                fetchHealthInfo()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func fetchHealthInfo() {
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // In real code: fetch from server based on patientName or ID
            self.height = 165.0
            self.weight = 60.0
            self.bloodType = "O+"
            self.isLoading = false
        }
    }
}


struct HealthInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()

            Text(value)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

