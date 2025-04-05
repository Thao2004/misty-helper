//
//  LoginViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    func login(completion: @escaping (Bool, String) -> Void) {
        guard !username.isEmpty, !password.isEmpty else {
            completion(false, "Please enter both email and password.")
            return
        }

        guard let url = URL(string: "http://10.226.105.114:8000/login/") else {
            completion(false, "Invalid server URL.")
            return
        }

        let payload: [String: Any] = [
            "username": username,
            "password": password
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            completion(false, "Failed to encode login data.")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true, "Login successful!")
                    } else {
                        if let data = data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            completion(false, errorMessage)
                        } else {
                            completion(false, "Login failed with status code \(httpResponse.statusCode).")
                        }
                    }
                } else {
                    completion(false, "Unexpected response.")
                }
            }
        }.resume()
    }
}


