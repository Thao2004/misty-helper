//
//  PatientDetailView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: Patient
    let caregiverId: Int 
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Misty background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle center glow
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 350
            )
            .ignoresSafeArea()

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

                // Patient name
                Text(patient.fullName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // Buttons
                VStack(spacing: 16) {
                    NavigationLink(destination: HealthInfoView(patientId: patient.id, patientName: patient.fullName)) {
                        PatientDetailButton(title: "Health Info", systemImage: "heart.text.square.fill")
                    }
                    
                    NavigationLink(destination: CheckupHistoryView(patientName: patient.fullName, patientId: patient.id)) {
                        PatientDetailButton(title: "Checkup History", systemImage: "clock.arrow.circlepath")
                    }
                    
                    NavigationLink(destination: Text("Medication List for \(patient.fullName)")) {
                        PatientDetailButton(title: "Medication List", systemImage: "pills.fill")
                    }
                    
                    NavigationLink(destination: NewCheckupView(caregiverId: caregiverId, patientId: patient.id)) {
                        PatientDetailButton(title: "Set New Check Up", systemImage: "calendar.badge.plus")
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct PatientDetailButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(Color(red: 0.07, green: 0.24, blue: 0.49))

            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
