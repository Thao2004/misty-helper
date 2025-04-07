//
//  CheckupHistoryViewModel.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import Foundation

struct CombinedCheckup: Identifiable {
    let id: Int
    let checkup: CheckupItem?
    let response: CheckupResponse?
    
    var hasResponse: Bool {
        return response != nil
    }
}

struct CheckupItem: Codable {
    let id: Int
    let checkup_time_start: String
    let checkup_time_end: String
    let questions: String
    let measure_temperature: Bool
    let status: String
    var parsedQuestions: [String] {
        if let data = questions.data(using: .utf8),
           let list = try? JSONSerialization.jsonObject(with: data) as? [String] {
            return list
        }
        return []
    }

}

struct CheckupResponse: Codable {
    let id: Int
    let checkup: Int
    let responses: String
    let temperature: Double?
    let responded_at: String?
    
    var parsedResponses: [String: String] {
        if let data = responses.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: String] {
            return json
        }
        return [:]
    }
}

class CheckupHistoryViewModel: ObservableObject {
    @Published var combinedCheckups: [CombinedCheckup] = []
    
    func fetchCheckups(for patientId: Int) {
        guard let url = URL(string: "http://10.226.17.124:8000/patients/\(patientId)/checkups/") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
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
                    if let rawList = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        var checkups: [CheckupItem] = []
                        var responses: [CheckupResponse] = []
                        
                        for item in rawList {
                            if let type = item["type"] as? String {
                                let jsonData = try JSONSerialization.data(withJSONObject: item)
                                if type == "checkup" {
                                    let checkup = try JSONDecoder().decode(CheckupItem.self, from: jsonData)
                                    checkups.append(checkup)
                                } else if type == "response" {
                                    let response = try JSONDecoder().decode(CheckupResponse.self, from: jsonData)
                                    responses.append(response)
                                }
                            }
                        }
                        
                        // 1. Create a dictionary to speed up response lookup
                        let responseMap = Dictionary(uniqueKeysWithValues: responses.map { ($0.checkup, $0) })
                        
                        // 2. Match responses with checkups
                        var combined: [CombinedCheckup] = checkups.map { checkup in
                            let matchedResponse = responseMap[checkup.id]
                            return CombinedCheckup(id: checkup.id, checkup: checkup, response: matchedResponse)
                        }
                        
                        // 3. Add unmatched responses
                        let unmatched = responses.filter { response in
                            !checkups.contains(where: { $0.id == response.checkup })
                        }
                        
                        let unmatchedCombined = unmatched.map {
                            CombinedCheckup(id: $0.id, checkup: nil, response: $0)
                        }
                        
                        combined.append(contentsOf: unmatchedCombined)
                        
                        // 4. Sort (by checkup start or response time)
                        self.combinedCheckups = combined.sorted {
                            let firstTime = $0.checkup?.checkup_time_start ?? $0.response?.responded_at ?? ""
                            let secondTime = $1.checkup?.checkup_time_start ?? $1.response?.responded_at ?? ""
                            return firstTime > secondTime
                        }
                    }
                } catch {
                    print("Decode error: \(error)")
                }
            }
        }.resume()
    }
}

