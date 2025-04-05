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

        let payload: [String: Any] = [
            "username": username,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "hospital": hospital,
            "date_of_birth": formattedBirthDate
        ]

        guard let url = URL(string: "http://10.226.105.114:8000/register/caregiver/") else {
            alertMessage = "Invalid URL."
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            alertMessage = "Failed to encode data."
            showAlert = true
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        alertMessage = "Caregiver registered successfully!"
                    } else {
                        // Try to decode error message from response
                        if let data = data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            alertMessage = "Failed: \(errorMessage)"
                        } else {
                            alertMessage = "Registration failed with status code \(httpResponse.statusCode)"
                        }
                    }
                    showAlert = true
                }
            }
        }.resume()
    }

}
