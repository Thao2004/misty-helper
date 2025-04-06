//
//  ScheduledCheckupListView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct ScheduledCheckupListView: View {
    let patientId: Int
    @StateObject private var viewModel = ScheduledCheckupViewModel()

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

            VStack(spacing: 20) {
                Text("Scheduled Checkups")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                if viewModel.scheduledCheckups.isEmpty {
                    ProgressView("Loading checkups...")
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.scheduledCheckups, id: \.id) { checkup in
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("\(formattedDate(checkup.checkup_time_start)) - \(formattedDate(checkup.checkup_time_end))", systemImage: "clock")
                                        .foregroundColor(.white)
                                    Label("Questions: \(checkup.parsedQuestions.count)", systemImage: "list.bullet")
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(16)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.fetchScheduledCheckups(for: patientId)
            }
        }
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
