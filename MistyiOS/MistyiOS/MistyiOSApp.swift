//
//  MistyiOSApp.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

@main
struct MistyiOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                //SplashScreenView()
                CaregiverDashboardView()
            }
        }
    }
}
