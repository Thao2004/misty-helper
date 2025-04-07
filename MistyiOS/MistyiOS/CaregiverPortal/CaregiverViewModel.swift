//
//  CaregiverViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import Foundation

class CaregiverViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var hospital: String = ""
    @Published var dateOfBirth: String = ""

    var formattedDOB: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateOfBirth) {
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: date)
        }
        return dateOfBirth // fallback in case formatting fails
    }

    var initials: String {
        let parts = fullName.split(separator: " ")
        return parts.prefix(2).map { String($0.first ?? " ") }.joined()
    }

    func fetchCaregiverInfo(userId: Int) {
        guard let url = URL(string: "http://10.226.17.124:8000/caregivers/\(userId)/") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Fetch error: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let first = json["first_name"] as? String,
                       let last = json["last_name"] as? String,
                       let email = json["email"] as? String,
                       let hospital = json["hospital"] as? String,
                       let dob = json["date_of_birth"] as? String {
                        self.fullName = "\(first) \(last)"
                        self.email = email
                        self.hospital = hospital
                        self.dateOfBirth = dob
                    } else {
                        print("Invalid data structure")
                    }
                } catch {
                    print("Decode error: \(error)")
                }
            }
        }.resume()
    }
}
