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
    @State private var isDashboardPresented = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign in to Misty")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.login { success, message in
                        if success {
                            isDashboardPresented = true
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
                Alert(title: Text("Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            // This modifier is attached to the NavigationStack and handles navigation.
            .navigationDestination(isPresented: $isDashboardPresented) {
                HomeDashboardView()
            }
        }
    }
}


#Preview {
    LoginView()
}
