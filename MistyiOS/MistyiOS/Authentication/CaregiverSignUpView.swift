//
//  CaregiverSignUpView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct CaregiverSignUpView: View {
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthDate = Date()
    @State private var hospital = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: birthDate)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Caregiver Sign Up")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Group {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                TextField("Hospital", text: $hospital)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .autocapitalization(.words)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Button("Sign Up") {
                signUp()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)

            Spacer()
        }
        .alert("Info", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func signUp() {
        if [username, firstName, lastName, email, password, hospital].contains(where: \.isEmpty) {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        // Example POST payload
        let payload: [String: Any] = [
            "username": username,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "hospital": hospital,
            "date_of_birth": formattedBirthDate
        ]

        alertMessage = "Caregiver registered successfully!\n\(payload)"
        showAlert = true

        // TODO: Connect to Django API endpoint here
    }
}
