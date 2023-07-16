//
//  GameView.swift
//  ColorMatching
//
//  Created by Aman Singh To on 2023-03-20.
//

import SwiftUI

struct GameView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 10
    @State private var targetColor = Color.random()
    @State private var userColor = Color.white
    @State private var offset = CGSize.zero
    @State private var score = 0
    @State private var lives = 3
    @State private var tolerance: Double = 0.2
    @State private var message: String = ""
    @State var showMessage = false
    @State var messageColor: Color = .black
    @State var endGame = false
    
    private func resetGame() {
        targetColor = Color.random()
        userColor = targetColor.randomColorCloseBy(tolerance: Double.random(in: 0.2...0.4))
        timeRemaining = 10
    }
    
    private func submitAnswer() {
        if userColor.isSimilar(to: targetColor, tolerance: tolerance) {
            message = "Nice, you guessed the color!"
            score += timeRemaining * 10 + 10
            showMessage = true
            messageColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showMessage = false
            }
            resetGame()
        } else {
            message = "Oops! That's not the correct color."
            score -= timeRemaining * 1
            lives -= 1
            showMessage = true
            messageColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showMessage = false
            }
            resetGame()
        }
        if score < 0 {
            score = 0
        }
        if lives < 1 {
            endGame = true
        }
    }
    
    var body: some View {
        let scale = max(0.1, CGFloat(timeRemaining) / 10)
        
        VStack {
            Text("Match the colors!")
                .font(.system(size: 54)).fontWidth(.expanded).bold()
                .multilineTextAlignment(.center)
                .padding()
            Text("\(timeRemaining)")
                .font(.system(size: 100).width(.expanded).weight(.heavy))
                .padding(.bottom)
            
            HStack {
                ColorCircle(color: $userColor, offset: .constant(.zero))
                ColorCircle(color: $targetColor, offset: .constant(.zero))
                    .scaleEffect(scale)
                    .animation(.spring(response: 0.8, dampingFraction: 0.3), value: scale)
            }
            .padding()
            
            Button(action: submitAnswer) {
                Text("GO")
                    .font(.title3).bold()
                    .padding(30)
                    .background(Circle().stroke(lineWidth: 5))
                    .foregroundColor(.primary)
                    .mask(Circle())
            }
            .padding()
            
            HStack {
                Text("Score: \(score) | Lives: \(lives)")
            }
            .font(.title3).fontWeight(.medium)
        }
        .opacity(endGame ? 0 : 1)
        .overlay(
            VStack {
                Text(message)
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
            }
                .background(messageColor)
                .cornerRadius(10)
                .opacity(showMessage ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5), value: showMessage)
                .opacity(endGame ? 0 : 1)
        )
        .overlay(
            VStack {
                Text("Congratulations, your final score is")
                    .font(.largeTitle.width(.expanded))
                    .multilineTextAlignment(.center)
                Text("\(score)")
                    .font(.system(size: 100).width(.expanded))
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                Button(action: {
                    resetGame()
                    endGame = false
                    score = 0
                    lives = 3
                }) {
                    Text("Reset")
                        .font(.title3).bold()
                        .padding(30)
                        .background(Circle().stroke(lineWidth: 5).foregroundStyle(.white))
                        .foregroundColor(.white)
                        .mask(Circle())
                }
            }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 2)
                        .fill(.white)
                )
                .padding(8)
                .opacity(endGame ? 1 : 0)
                .scaleEffect(endGame ? 1 : 0.7)
                .animation(.spring(response: 0.7, dampingFraction: 0.7), value: endGame)
        )
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                submitAnswer()
            }
        }
        .onAppear {
            resetGame()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
