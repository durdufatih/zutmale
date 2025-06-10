import SwiftUI
import AVFoundation
import UIKit

struct StoryResultView: View {
    let storyText: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isSpeaking = false
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Your Story")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Color.green)
                .padding(.top, 20)
            ScrollView {
                Text(storyText)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemGreen).opacity(0.08))
                    .cornerRadius(18)
                    .padding(.horizontal)
            }
            HStack(spacing: 24) {
                Button(action: {
                    readAloud()
                }) {
                    HStack {
                        Image(systemName: isSpeaking ? "pause.fill" : "speaker.wave.2.fill")
                        Text(isSpeaking ? "Pause" : "Read Aloud")
                    }
                    .font(.title3)
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(18)
                }
                Button(action: {
                    shareStory()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.title3)
                    .padding()
                    .background(Color.yellow.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(18)
                }
            }
            
            Button(action: {
                // Stop reading if active when leaving the screen
                if isSpeaking {
                    speechSynthesizer.stopSpeaking(at: .immediate)
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to Builder")
                    .font(.body)
                    .foregroundColor(Color.green)
                    .underline()
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color(.systemGreen).opacity(0.07).ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            // Make sure to stop speaking if the view disappears
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
        }
    }
    
    private func readAloud() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            let utterance = AVSpeechUtterance(string: storyText)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            // Daha yavaş ve masalsı okuma için rate'i düşürüyoruz (0.0-1.0 aralığında)
            utterance.rate = 0.38  // Daha yavaş okuma hızı (0.5'ten daha yavaş)
            utterance.pitchMultiplier = 1.05  // Daha doğal ses tonu için hafif ayarlama
            utterance.volume = 0.9  // Ses seviyesi
            utterance.postUtteranceDelay = 0.8  // Cümleler arası daha uzun duraklamalar için
            speechSynthesizer.speak(utterance)
            isSpeaking = true
        }
    }
    
    private func shareStory() {
        let activityVC = UIActivityViewController(
            activityItems: [storyText],
            applicationActivities: nil
        )
        
        // Find the currently active window scene for presenting
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    StoryResultView(storyText: "Once upon a time, in a land far, far away, there lived a brave knight who fought dragons and saved kingdoms. His adventures were legendary, and his courage unmatched. This is the story of his greatest quest...")
}
