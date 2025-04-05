//
//  LoginViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Default credentials for testing
    private let defaultEmail = "Test@example.com"
    private let defaultPassword = "Password123"
    
    func login(completion: @escaping (Bool, String) -> Void) {
        // Validate with default credentials
        if email == defaultEmail && password == defaultPassword {
            completion(true, "")  // Login successful
        } else {
            completion(false, "Invalid email or password. Please try again.")  // Login failed
        }
    }
}

