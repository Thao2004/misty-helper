//
//  CaregiverDashboardView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct CaregiverDashboardView: View {
    init() {
        // Customize tab bar appearance globally
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.clear
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            NavigationStack {
                ZStack {
                    // Background Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.27, green: 0.51, blue: 0.79),
                            Color(red: 0.42, green: 0.74, blue: 0.96)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    // Radial glow center
                    RadialGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.25), Color.clear]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 300
                    )
                    .ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 30) {
                        // Welcome Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome Back!")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)

                            Text("Jonathan Patterson")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .padding(.top, 40) // Moved up slightly
                        
                        
                        // Patient List Button
                        NavigationLink(destination: PatientListView()) {
                            CaregiverDashboardButton(title: "Patient List", imageName: "person.3.fill")
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)

                        Spacer()
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
                    .foregroundColor(.white)
            }

            CaregiverProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                        .foregroundColor(.white)
                }
        }
        .accentColor(.white) // Ensures white icon + label in tab bar
    }
}

// MARK: - Dashboard Button
struct CaregiverDashboardButton: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 45)
                .foregroundColor(Color(red: 0.27, green: 0.51, blue: 0.79))

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CaregiverDashboardView()
}

