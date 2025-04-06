//
//  WelcomeScreenView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    
    @State private var showWelcome = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 40) {
                
                HStack {
                    Text("Welcome")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(showWelcome ? 1 : 0)
                        .offset(x: showWelcome ? 0 : -30)
                        .animation(.easeOut(duration: 1.2), value: showWelcome)
                        .padding(.leading, 20)
                        .padding(.top, 40)
                    Spacer()
                }
                .onAppear {
                    showWelcome = true
                }

                    
                Image("misty")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: Color.white.opacity(0.3), radius: 12)
                    .padding(.top, 40)



                Spacer(minLength: 150)

                // Sign In Button
                NavigationLink(destination: LoginView()) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.07, green: 0.24, blue: 0.49))
                        .cornerRadius(15)
                }

                // Sign Up Button
                NavigationLink(destination: RoleSelectionView()) {
                    Text("Sign Up")
                        .foregroundColor(Color(red: 0.07, green: 0.24, blue: 0.49))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.27, green: 0.51, blue: 0.79),
                        Color(red: 0.42, green: 0.74, blue: 0.96)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    WelcomeScreenView()
}
