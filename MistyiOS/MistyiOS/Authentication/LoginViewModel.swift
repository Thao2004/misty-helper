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
    @Published var role: String = ""
    @Published var userId: Int? = nil

    func login(completion: @escaping (Bool, String) -> Void) {
        guard !username.isEmpty, !password.isEmpty else {
            completion(false, "Please enter both username and password.")
            return
        }

        guard let url = URL(string: "http://10.226.17.124:8000/login/") else {
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
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
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

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    completion(false, "Unexpected server response.")
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let role = json["role"] as? String,
                           let userId = json["user_id"] as? Int {
                            self.role = role
                            self.userId = userId
                            completion(true, "Login successful!")
                        } else {
                            completion(false, "Failed to parse login response.")
                        }
                    } catch {
                        completion(false, "Decoding error: \(error.localizedDescription)")
                    }
                } else {
                    let message = String(data: data, encoding: .utf8) ?? "Login failed with status code \(httpResponse.statusCode)"
                    completion(false, message)
                }
            }
        }.resume()
    }
}



