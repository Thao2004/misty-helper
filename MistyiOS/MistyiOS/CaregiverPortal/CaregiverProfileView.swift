//
//  CaregiverProfileView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct CaregiverProfileView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Center radial glow
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 300
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("Caregiver Profile")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)

                // Profile avatar
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .overlay(Text("JP").font(.title).foregroundColor(.white))

                Text("Jonathan Patterson")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    HStack {
                        Text("Email:")
                            .bold()
                            .foregroundColor(.white)
                        Text("jonathan.p@hospital.com")
                            .foregroundColor(.white)
                    }
                    .font(.body)

                    HStack {
                        Text("Hospital:")
                            .bold()
                            .foregroundColor(.white)
                        Text("Central Health")
                            .foregroundColor(.white)
                    }
                    .font(.body)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CaregiverProfileView()
}


