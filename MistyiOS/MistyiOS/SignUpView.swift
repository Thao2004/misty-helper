//
//  SignUpView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var birthDate: String = "" // Changed to String for manual entry
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Create new Account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            // Already registered text with link to Login
            HStack {
                Text("Already Registered?")
                NavigationLink(destination: LoginView()) {
                    Text("Log in here")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.leading, 20)
            .font(.footnote)

            // Name input field
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Email input field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password input field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Date of birth input field (manual entry)
            TextField("Date of Birth (MM/DD/YYYY)", text: $birthDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Sign up button
            Button(action: {
                signUp()
            }) {
                Text("Sign up")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    // Sign up function to simulate validation
    private func signUp() {
        // Check for empty fields (or add additional validation)
        if name.isEmpty || email.isEmpty || password.isEmpty || birthDate.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        // Simulate successful sign-up
        alertMessage = "Account created successfully!"
        showAlert = true
    }
}




#Preview {
    SignUpView()
}
