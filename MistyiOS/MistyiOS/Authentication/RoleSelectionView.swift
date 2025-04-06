//
//  RoleSelectionView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

enum UserRole: String, CaseIterable, Identifiable {
    case patient, caregiver
    var id: String { self.rawValue }
}

struct RoleSelectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle radial white glow in the middle
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.2), .clear]),
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
                
                Spacer()
                
                Text("Select Your Role")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(.white)

                Text("Are you a patient or someone providing care?")
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                Spacer(minLength: 200)
                
                NavigationLink(destination: PatientSignUpView()) {
                    Label("Patient", systemImage: "person.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.07, green: 0.24, blue: 0.49))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                NavigationLink(destination: CaregiverSignUpView()) {
                    Label("Caregiver", systemImage: "stethoscope")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.07, green: 0.24, blue: 0.49))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}


#Preview {
    RoleSelectionView()
}
