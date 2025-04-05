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
                    .font(.custom("Snell Roundhand", size: 70))
                    .foregroundColor(.blue)
                    .padding()
                    .onAppear {
                        typeText()
                    }

                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
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
