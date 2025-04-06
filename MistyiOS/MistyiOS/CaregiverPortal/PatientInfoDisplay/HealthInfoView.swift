//
//  HealthInfoView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct HealthInfoView: View {
    let patientId: Int
    let patientName: String
    @Environment(\.dismiss) private var dismiss

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

                // Title
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
        guard let url = URL(string: "http://10.226.162.163:8000/patients/\(patientId)/healthinfo/") else {
            print("Invalid URL")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("API Error: \(error.localizedDescription)")
                    isLoading = false
                    return
                }

                guard let data = data else {
                    print("No data received")
                    isLoading = false
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        self.height = json["height"] as? Double
                        self.weight = json["weight"] as? Double
                        self.bloodType = json["blood_type"] as? String
                    } else {
                        print("Invalid JSON format")
                    }
                } catch {
                    print("Decoding error: \(error)")
                }

                isLoading = false
            }
        }.resume()
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

