//
//  MedicationListView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/6/25.
//

import SwiftUI

struct MedicationListView: View {
    let patientName: String
    let patientId: Int
    @StateObject private var viewModel = MedicationViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.27, green: 0.51, blue: 0.79),
                    Color(red: 0.42, green: 0.74, blue: 0.96)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("\(patientName)'s Medication Plan")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)

                if viewModel.plans.isEmpty {
                    ProgressView("Loading medications...")
                        .foregroundColor(.white)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.plans) { plan in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Date: \(formattedDate(plan.date))")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text("Frequency: \(plan.frequency)")
                                        .foregroundColor(.black)

                                    Text("Medications:")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)

                                    if plan.ameflu > 0 {
                                        Text("• Ameflu: \(plan.ameflu)").foregroundColor(.black)
                                    }
                                    if plan.effe > 0 {
                                        Text("• Efferalgan: \(plan.effe)").foregroundColor(.black)
                                    }
                                    if plan.lope > 0 {
                                        Text("• Loperamide: \(plan.lope)").foregroundColor(.black)
                                    }
                                    if plan.corbi > 0 {
                                        Text("• Corbivit: \(plan.corbi)").foregroundColor(.black)
                                    }
                                    if plan.doxy > 0 {
                                        Text("• Doxycycline: \(plan.doxy)").foregroundColor(.black)
                                    }

                                    if !plan.notes.isEmpty {
                                        Text("Notes: \(plan.notes)")
                                            .italic()
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(24)
                                .background(Color.white)
                                .cornerRadius(24)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                viewModel.fetchMedicationPlans(for: patientId)
            }
        }
    }

    private func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM/dd/yyyy"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}

