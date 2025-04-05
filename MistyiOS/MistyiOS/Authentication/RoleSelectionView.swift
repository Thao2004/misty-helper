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
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Role")
                .font(.title)
                .padding()

            NavigationLink(destination: PatientSignUpView()) {
                Text("Patient")
            }
            .buttonStyle(.bordered)

            NavigationLink(destination: CaregiverSignUpView()) {
                Text("Caregiver")
            }
            .buttonStyle(.bordered)
        }
    }
}


#Preview {
    RoleSelectionView()
}
