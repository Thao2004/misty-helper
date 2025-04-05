//
//  WelcomeScreenView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("Misty Care")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
            
            Image(systemName: "paperplane.fill") // Replace with the app logo
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
            
            NavigationLink(destination: LoginView()) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            NavigationLink(destination: RoleSelectionView()) {
                Text("Sign Up")
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
            }
            
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    WelcomeScreenView()
}
