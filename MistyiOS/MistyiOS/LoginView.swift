//
//  LoginView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Sign in to Misty")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Email input field
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password input field
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Log In button
            Button(action: {
                viewModel.login { success, message in
                    if success {
                        // Navigate to the next screen
                        print("Logged in successfully")
                    } else {
                        alertMessage = message
                        showAlert = true
                    }
                }
            }) {
                Text("Log in")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            // Forgot password and sign up links
            HStack {
                Button("Forgot password?") {
                    // Handle reset password action
                }
                Spacer()
                Button("Sign up!") {
                    // Handle sign-up action
                }
            }
            .font(.footnote)
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


#Preview {
    LoginView()
}
