//
//  PatientSignUpView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientSignUpView: View {
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthDate = Date()
    @State private var address = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Patient Sign Up")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Group {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                TextField("Address", text: $address)
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
                if [username, firstName, lastName, email, password, address].contains(where: \.isEmpty) {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                } else {
                    alertMessage = "Patient registered successfully!"
                    showAlert = true
                }
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
}
