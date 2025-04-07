//
//  NewCheckupView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import SwiftUI

struct NewCheckupView: View {
    let caregiverId: Int
    let patientId: Int
    
    @State private var checkupTimeStart = Date()
    @State private var checkupTimeEnd = Date().addingTimeInterval(3600)
    @State private var questions: [String] = [""]
    @State private var measureTemperature = false
    @State private var status = "scheduled"
    
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let statusOptions = ["scheduled", "in progress", "completed"]
    
    var body: some View {
        ZStack {
            // Misty background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("New Checkup")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Group {
                        DatePicker("Checkup Start Time", selection: $checkupTimeStart, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                        DatePicker("Checkup End Time", selection: $checkupTimeEnd, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading) {
                        Text("Questions")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(questions.indices, id: \.self) { index in
                            HStack {
                                TextField("Question \(index + 1)", text: $questions[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {
                                    questions.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Button(action: {
                            questions.append("")
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Question")
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.top, 5)
                    }
                    
                    Toggle("Measure Temperature", isOn: $measureTemperature)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Picker("Status", selection: $status) {
                        ForEach(statusOptions, id: \.self) { option in
                            Text(option.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Button(action: submitCheckup) {
                        HStack {
                            Spacer()
                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("Submit Checkup")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .alert("Checkup Submission", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func submitCheckup() {
        guard !questions.contains(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) else {
            alertMessage = "Please fill in all questions."
            showAlert = true
            return
        }
        
        isSubmitting = true
        let dateFormatter = ISO8601DateFormatter()
        
        // Debug logs
        print("Submitting checkup with:")
        print("Caregiver ID: \(caregiverId)")
        print("Patient ID: \(patientId)")
        
        let encodedQuestions = try? JSONSerialization.data(withJSONObject: questions)
        let questionsJSONString = String(data: encodedQuestions ?? Data(), encoding: .utf8) ?? "[]"
        
        let payload: [String: Any] = [
            "caregiver_user": caregiverId,
            "patient_user": patientId,
            "checkup_time_start": dateFormatter.string(from: checkupTimeStart),
            "checkup_time_end": dateFormatter.string(from: checkupTimeEnd),
            "selected_time": dateFormatter.string(from: Date()),
            "questions": questionsJSONString,
            "measure_temperature": measureTemperature,
            "status": status
        ]
        
        guard let url = URL(string: "http://10.226.17.124:8000/checkup/"),
              let body = try? JSONSerialization.data(withJSONObject: payload) else {
            alertMessage = "Invalid URL or request body"
            showAlert = true
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Submission failed: \(error.localizedDescription)"
                } else if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 201 {
                    alertMessage = "Checkup created successfully!"
                    resetForm()
                } else {
                    alertMessage = "Something went wrong. Please try again."
                }
                showAlert = true
            }
        }.resume()
    }

    
    private func resetForm() {
        checkupTimeStart = Date()
        checkupTimeEnd = Date().addingTimeInterval(3600)
        questions = [""]
        measureTemperature = false
        status = "scheduled"
    }
}
