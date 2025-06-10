//
//  ContentView.swift
//  hello-test
//
//  Created by Mehmet Fatih Durdu on 9.06.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var randomNumber = Int.random(in: 1...20)
    @State private var userGuess = ""
    @State private var message = "1-20 arasında bir sayı tahmin et!"
    @State private var attemptsLeft = 5
    @State private var gameOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Sayı Tahmin Oyunu")
                .font(.title)
                .bold()
            Text(message)
                .foregroundColor(.blue)
            TextField("Tahminini gir", text: $userGuess)
            
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(gameOver)
                .padding(10)
            Button("Tahmin Et") {
                guessNumber()
            }
            .disabled(gameOver)
            Text("Kalan Hak: \(attemptsLeft)")
                .foregroundColor(.red)
            if gameOver {
                Button("Yeniden Başla") {
                    resetGame()
                }
            }
        }
        .padding()
    }
    
    func guessNumber() {
        guard let guess = Int(userGuess), guess >= 1, guess <= 20 else {
            message = "Lütfen 1-20 arasında bir sayı gir."
            return
        }
        if guess == randomNumber {
            message = "Bildin! Doğru sayı: \(randomNumber)"
            gameOver = true
        } else {
            attemptsLeft -= 1
            if attemptsLeft == 0 {
                message = "Bilemedin! Doğru sayı: \(randomNumber)"
                gameOver = true
            } else if guess < randomNumber {
                message = "Daha büyük bir sayı dene!"
            } else {
                message = "Daha küçük bir sayı dene!"
            }
        }
        userGuess = ""
    }
    
    func resetGame() {
        randomNumber = Int.random(in: 1...20)
        attemptsLeft = 5
        userGuess = ""
        message = "1-20 arasında bir sayı tahmin et!"
        gameOver = false
    }
}

#Preview {
    ContentView()
}
