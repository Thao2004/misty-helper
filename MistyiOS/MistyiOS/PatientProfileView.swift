//
//  PatientProfileView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import SwiftUI

struct PatientProfileView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel

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
                Text("Patient Profile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)

                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(getInitials())
                            .font(.title)
                            .foregroundColor(.white)
                    )

                Text(viewModel.fullName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                VStack(spacing: 12) {
                    ProfileRow(label: "Email", value: viewModel.email)
                    ProfileRow(label: "Address", value: viewModel.address)
                    ProfileRow(label: "Date of Birth", value: viewModel.formattedDOB)
                }
                .padding()
                .background(Color.white.opacity(0.12))
                .cornerRadius(16)

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
    }

    private func getInitials() -> String {
        let parts = viewModel.fullName.split(separator: " ")
        return parts.prefix(2).map { String($0.prefix(1)) }.joined()
    }
}

struct ProfileRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label):")
                .bold()
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}
