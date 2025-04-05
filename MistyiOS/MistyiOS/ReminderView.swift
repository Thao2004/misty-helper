//
//  ReminderView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI
import Foundation

struct Task: Identifiable {
    var id = UUID()
    var title: String
}

struct ReminderView: View {
    @State private var reminders: [Task] = []  // Array to hold reminders
    @State private var newReminderTitle: String = ""  // New reminder input
    @State private var isAddingReminder: Bool = false  // Flag to show/hide reminder creation
    
    var body: some View {
        VStack {
            // Title
            Text("Reminder List")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Show message if there are no reminders
            if reminders.isEmpty {
                Text("There are no reminders.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()

            } else {
                // List of reminders
                List(reminders) { reminder in
                    Text(reminder.title)
                }
                .padding(.top, 20)
            }

            // Add Reminder Button
            Button(action: {
                isAddingReminder.toggle()
            }) {
                Text("Add Reminder")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.top, 20)
            }
            
            // Showing the "Add Reminder" form
            if isAddingReminder {
                VStack(spacing: 20) {
                    TextField("Enter reminder title", text: $newReminderTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    // Save Reminder Button
                    Button(action: addReminder) {
                        Text("Save Reminder")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)

                    // Cancel Button
                    Button(action: {
                        isAddingReminder = false
                        newReminderTitle = ""
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red))
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    // Function to add a reminder
    private func addReminder() {
        guard !newReminderTitle.isEmpty else { return }  // Don't add if title is empty
        let newReminder = Task(title: newReminderTitle)
        reminders.append(newReminder)
        newReminderTitle = ""  // Reset input field
        isAddingReminder = false  // Hide the reminder input form
    }
}


#Preview {
    ReminderView()
}
