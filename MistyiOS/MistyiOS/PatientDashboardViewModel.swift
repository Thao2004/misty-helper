//
//  PatientDashboardViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import Foundation

class PatientDashboardViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var dateOfBirth: String = ""
    @Published var userId: Int?

    var formattedDOB: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateOfBirth) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy"
            return outputFormatter.string(from: date)
        }
        return "N/A"
    }

    func fetchPatientInfo(userId: Int) {
        self.userId = userId
        guard let url = URL(string: "http://10.226.17.124:8000/patients/\(userId)/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let first = json["first_name"] as? String,
                       let last = json["last_name"] as? String {
                        self.fullName = "\(first) \(last)"
                        self.email = json["email"] as? String ?? ""
                        self.address = json["address"] as? String ?? ""
                        self.dateOfBirth = json["date_of_birth"] as? String ?? ""
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}


