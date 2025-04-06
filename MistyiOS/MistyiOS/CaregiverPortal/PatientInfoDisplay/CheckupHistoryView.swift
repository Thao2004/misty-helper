//
//  CheckupHistoryView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct CheckupHistoryView: View {
    let patientName: String
    let patientId: Int
    @StateObject private var viewModel = CheckupHistoryViewModel()

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

            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                center: .center,
                startRadius: 10,
                endRadius: 350
            ).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("\(patientName)'s Checkups")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)

                    if viewModel.combinedCheckups.isEmpty {
                        ProgressView("Loading checkups...")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ForEach(viewModel.combinedCheckups, id: \.id) { checkup in
                            VStack(alignment: .leading, spacing: 12) {
                                if let start = checkup.checkup?.checkup_time_start,
                                   let end = checkup.checkup?.checkup_time_end {
                                    Label("\(formattedDate(start)) - \(formattedDate(end))", systemImage: "clock")
                                        .foregroundColor(.black)
                                }

                                if let questions = checkup.checkup?.parsedQuestions, !questions.isEmpty {
                                    Label("Questions", systemImage: "list.bullet")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    ForEach(questions, id: \.self) { question in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Q: \(question)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            if let answer = checkup.response?.parsedResponses[question] {
                                                Text("A: \(answer)")
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text("A: No response.")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }

                                if let measureTemp = checkup.checkup?.measure_temperature, measureTemp {
                                    Label("Measure Temp: Yes", systemImage: "thermometer")
                                        .foregroundColor(.black)
                                    if let temp = checkup.response?.temperature {
                                        Text("• \(String(format: "%.1f", temp)) °C")
                                            .foregroundColor(.gray)
                                    }
                                }

                                if let status = checkup.checkup?.status {
                                    Label("Status: \(status.capitalized)", systemImage: "pin.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
            .onAppear {
                viewModel.fetchCheckups(for: patientId)
            }
        }
        .navigationBarBackButtonHidden(false)
    }

    private func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, h:mm a"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}

