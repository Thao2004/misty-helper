//
//  PatientSignUpView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct PatientSignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var birthDate = Date()
    @State private var address = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var goToLogin = false

    var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: birthDate)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient + subtle center glow
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
                    gradient: Gradient(colors: [Color.white.opacity(0.15), .clear]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 350
                )
                .ignoresSafeArea()

                VStack(spacing: 25) {
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

                    Text("Patient Sign Up")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Group {
                        Group {
                            TextField("First Name", text: $firstName)
                            TextField("Last Name", text: $lastName)
                            DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
                                .foregroundColor(.black)
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
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                    }

                    Button(action: {
                        signUp()
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.07, green: 0.24, blue: 0.49))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)

                    Spacer()

                    // Hidden navigation to login
                    NavigationLink(destination: LoginView(), isActive: $goToLogin) {
                        EmptyView()
                    }
                }
            }
            .alert("Info", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func signUp() {
        if [username, firstName, lastName, email, password, address].contains(where: \.isEmpty) {
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
            "address": address,
            "date_of_birth": formattedBirthDate
        ]

        guard let url = URL(string: "http://10.226.173.27:8000/register/patient/") else {
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
                        alertMessage = "Patient registered successfully!"
                        showAlert = true

                        // Navigate to LoginView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            goToLogin = true
                        }
                    } else {
                        if let data = data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            alertMessage = "Failed: \(errorMessage)"
                        } else {
                            alertMessage = "Registration failed with code \(httpResponse.statusCode)"
                        }
                        showAlert = true
                    }
                }
            }
        }.resume()
    }
}


