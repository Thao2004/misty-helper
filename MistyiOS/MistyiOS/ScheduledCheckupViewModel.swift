//
//  ScheduledCheckupViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import Foundation

struct ScheduledCheckup: Identifiable, Codable {
    let id: Int
    let checkup_time_start: String
    let checkup_time_end: String
    let questions: String
    let status: String

    var parsedQuestions: [String] {
        if let data = questions.data(using: .utf8),
           let list = try? JSONSerialization.jsonObject(with: data) as? [String] {
            return list
        }
        return []
    }
}

class ScheduledCheckupViewModel: ObservableObject {
    @Published var scheduledCheckups: [ScheduledCheckup] = []

    func fetchScheduledCheckups(for patientId: Int) {
        guard let url = URL(string: "http://10.226.162.163:8000/patients/\(patientId)/checkups/") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Fetch error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data")
                    return
                }

                do {
                    if let rawList = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        let filtered = rawList
                            .filter { $0["type"] as? String == "checkup" && $0["status"] as? String == "scheduled" }
                            .compactMap { dict -> ScheduledCheckup? in
                                guard let jsonData = try? JSONSerialization.data(withJSONObject: dict) else { return nil }
                                return try? JSONDecoder().decode(ScheduledCheckup.self, from: jsonData)
                            }
                        self.scheduledCheckups = filtered
                    }
                } catch {
                    print("JSON parse error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
