//
//  CaregiverDashboardView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct CaregiverDashboardView: View {
    @StateObject private var viewModel = CaregiverViewModel()
    let userId: Int

    init(userId: Int) {
        self.userId = userId

        // Tab bar appearance
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
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.27, green: 0.51, blue: 0.79),
                            Color(red: 0.42, green: 0.74, blue: 0.96)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    RadialGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.25), .clear]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 300
                    )
                    .ignoresSafeArea()

                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome Back!")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)

                            Text(viewModel.fullName.isEmpty ? "Loading..." : viewModel.fullName)
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
                        NavigationLink(destination: PatientListView(caregiverId: userId)) {
                            CaregiverDashboardButton(title: "Patient List", imageName: "person.3.fill")
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)

                        Spacer()
                    }
                }
                .onAppear {
                    viewModel.fetchCaregiverInfo(userId: userId)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            CaregiverProfileView(userId: userId)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
        .accentColor(.white)
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
    CaregiverDashboardView(userId: 1)
}
