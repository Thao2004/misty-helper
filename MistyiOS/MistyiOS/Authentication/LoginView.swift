//
//  LoginView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isDashboardPresented = false
    @State private var goToSignUp = false

    var body: some View {
        NavigationStack {
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

                VStack(spacing: 20) {
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

                    // Title
                    VStack(spacing: 8) {
                        Text("Login")
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Sign in to Misty")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 150)

                    // Username
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // Password
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 30)

                    // Login Button
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
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.07, green: 0.24, blue: 0.49))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Forgot password / Sign up
                    HStack {
                        Button("Forgot password?") {
                            // TODO
                        }
                        .foregroundColor(.white.opacity(0.85))
                        .font(.system(size: 15, weight: .medium))

                        Spacer()

                        Button("Sign up!") {
                            goToSignUp = true
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .bold))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                // Navigate to Home
                NavigationLink(destination: PatientDashboardView(), isActive: $isDashboardPresented) {
                    EmptyView()
                }

                // Navigate to Sign Up
                NavigationLink(destination: RoleSelectionView(), isActive: $goToSignUp) {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true) // Hides default back
        }
    }
}

#Preview {
    LoginView()
}
