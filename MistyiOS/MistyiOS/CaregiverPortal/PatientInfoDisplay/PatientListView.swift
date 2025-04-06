//
//  PatientListView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PatientListViewModel()

    let caregiverId: Int

    var body: some View {
        ZStack {
            // Misty Gradient Background
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
                gradient: Gradient(colors: [Color.white.opacity(0.2), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 350
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
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

                Text("Your Patients")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top, 30)

                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(viewModel.patients) { patient in
                            NavigationLink(destination: PatientDetailView(patient: patient, caregiverId: caregiverId)) {
                                HStack(spacing: 16) {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)

                                    Text(patient.fullName)
                                        .foregroundColor(.primary)
                                        .fontWeight(.semibold)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchPatients(for: caregiverId)
        }
        .navigationBarBackButtonHidden(true)
    }
}

