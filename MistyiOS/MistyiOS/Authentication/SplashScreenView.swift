//
//  SplashScreenView.swift
//  MistyiOS
//
//  Created by Nguyen Hoang Mai Thao on 4/5/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var visibleText = ""
    private let fullText = "Misty Care"
    private let typingSpeed = 0.15 // seconds per character

    var body: some View {
        if isActive {
            WelcomeScreenView()
        } else {
            VStack {
                Spacer()
                
                Text(visibleText)
                    .font(.custom("Georgia", size: 60))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .onAppear {
                        typeText()
                    }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    func typeText() {
        var charIndex = 0
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                visibleText.append(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
                // Wait a bit after text fully appears, then navigate
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreenView()
}
