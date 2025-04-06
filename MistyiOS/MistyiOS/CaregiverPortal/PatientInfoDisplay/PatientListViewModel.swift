//
//  PatientListViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import Foundation

struct Patient: Identifiable, Decodable {
    let id: Int
    let first_name: String
    let last_name: String

    var fullName: String {
        "\(first_name) \(last_name)"
    }
}

class PatientListViewModel: ObservableObject {
    @Published var patients: [Patient] = []

    func fetchPatients(for caregiverId: Int) {
        guard let url = URL(string: "http://10.226.162.163:8000/caregivers/\(caregiverId)/patients/") else {
            print("Invalid URL for caregiver ID \(caregiverId)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to fetch patients: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data returned")
                    return
                }

                do {
                    self.patients = try JSONDecoder().decode([Patient].self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}
