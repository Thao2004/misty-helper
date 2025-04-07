//
//  MedicationViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import Foundation

class MedicationViewModel: ObservableObject {
    @Published var plans: [MedicationPlan] = []

    func fetchMedicationPlans(for patientUserId: Int) {
        guard let url = URL(string: "http://10.226.17.124:8000/patients/\(patientUserId)/medications/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching meds: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    self.plans = try JSONDecoder().decode([MedicationPlan].self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}

struct MedicationPlan: Codable, Identifiable {
    let id: Int
    let patient_user_id: Int
    let caregiver_user_id: Int
    let date: String
    let frequency: String
    let ameflu: Int
    let effe: Int
    let lope: Int
    let corbi: Int
    let doxy: Int
    let notes: String
    let created_at: String

    var readableMedications: [String] {
        var meds: [String] = []
        if ameflu == 1 { meds.append("Ameflu") }
        if effe == 1 { meds.append("Efferalgan") }
        if lope == 1 { meds.append("Loperamide") }
        if corbi == 1 { meds.append("Corbivit") }
        if doxy == 1 { meds.append("Doxycycline") }
        return meds
    }
}

