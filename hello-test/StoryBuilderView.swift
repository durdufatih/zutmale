import SwiftUI
import GoogleGenerativeAI

struct StoryBuilderView: View {
    var onGenerate: (_ prompt:String) async -> String = { prompt in
        print("Generating story with prompt: \(prompt)")
        let model = GenerativeModel(name: "gemini-2.5-flash-preview-05-20", apiKey: "AIzaSyBjsty41nRZE_z-GaxleDgWCao0c0mIYgc")
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text, !text.isEmpty {
                return text
            } else {
                return "No story generated."
            }
        } catch {
            print("Error generating content: \(error.localizedDescription)")
            return "Error: \(error.localizedDescription)"
        }
    }
    var onBack: () -> Void = {}
    @State private var selectedAge = 5
    @State private var selectedTheme = "Courage"
    @State private var characterName = ""
    @State private var storyLength = "Medium"
    @State private var showResult = false
    @State private var generatedStory = ""
    @State private var navigateToResult = false
    @State private var isLoading = false
    
    let themes = [
        "Courage", "Sharing", "Fear", "Imagination", "Friendship", "Kindness", "Adventure", "Honesty", "Teamwork", "Respect"
    ]
    let lengths = ["Short", "Medium", "Long"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 28) {
                    Text("Create Your Story")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Color.blue)
                        .padding(.top, 20)
                    Form {
                        Section(header: Text("Child's Age").font(.headline)) {
                            Picker("Age", selection: $selectedAge) {
                                ForEach(1...7, id: \.self) { age in
                                    Text("\(age)")
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        Section(header: Text("Story Theme").font(.headline)) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Choose a theme:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                VStack(spacing: 12) {
                                    ForEach(themes, id: \.self) { theme in
                                        ThemeButton(
                                            theme: theme,
                                            isSelected: selectedTheme == theme,
                                            onSelect: {
                                                selectedTheme = theme
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        Section(header: Text("Character Name (optional)").font(.headline)) {
                            TextField("e.g. Lily", text: $characterName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Section(header: Text("Story Length").font(.headline)) {
                            Picker("Length", selection: $storyLength) {
                                ForEach(lengths, id: \.self) { length in
                                    Text(length)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .background(Color(.systemBlue).opacity(0.04))
                    Button(action: {
                        var name = characterName.isEmpty ? "a little hero" : characterName
                        var prompt = "Write a children's story for a child aged \(selectedAge) about the theme of \(selectedTheme.lowercased()). The main character's name is \(name). The story should be \(storyLength.lowercased()) in length."
                        Task {
                            isLoading = true
                            let result = await onGenerate(prompt)
                            generatedStory = result
                            navigateToResult = true
                            isLoading = false
                        }
                    }) {
                        Text("Generate Story")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(18)
                    }
                    .padding(.horizontal, 32)
        
                    
                    Button(action: {
                        onBack()
                    }) {
                        Text("Back")
                            .font(.body)
                            .foregroundColor(Color.blue)
                            .underline()
                    }
                    Spacer()
                }
                .background(Color(.systemBlue).opacity(0.07).ignoresSafeArea())
            
                
                // NavigationLink to StoryResultView
                NavigationLink(destination: StoryResultView(storyText: generatedStory),
                              isActive: $navigateToResult) {
                    EmptyView()
                }
                
                // Show loading overlay when generating story
                if isLoading {
                    loadingOverlay
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // Loading overlay view
    private var loadingOverlay: some View {
        ZStack {
            // Yarı saydam arka plan
            Color.blue.opacity(0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Renkli animasyonlu yükleme göstergesi
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.blue.opacity(0.3))
                    
                    ForEach(0..<3) { index in
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.blue, .purple, .pink]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80 + CGFloat(index * 20), height: 80 + CGFloat(index * 20))
                            .rotationEffect(.degrees(Double(index * 120)))
                            .rotationEffect(.degrees(isLoading ? 360 : 0))
                            .animation(
                                Animation.linear(duration: Double(index + 2))
                                    .repeatForever(autoreverses: false),
                                value: isLoading
                            )
                    }
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .scaleEffect(isLoading ? 1.2 : 1.0)
                        .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isLoading)
                }
                .padding(.bottom, 10)
                
                Text("Creating Your Magical Story...")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                
                Text("Our magical storytellers are writing\njust for you!")
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.blue.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(
                        color: Color.blue.opacity(0.3),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            )
            .padding(.horizontal, 40)
            .onAppear {
                // Animasyonu başlatmak için
                isLoading = true
            }
        }
    }
}

// Helper function for theme icons
func themeIcon(for theme: String) -> String {
    switch theme {
    case "Courage": return "bolt.heart"
    case "Sharing": return "person.2.fill"
    case "Fear": return "exclamationmark.triangle.fill"
    case "Imagination": return "sparkles"
    case "Friendship": return "hands.sparkles.fill"
    case "Kindness": return "heart.fill"
    case "Adventure": return "map.fill"
    case "Honesty": return "checkmark.seal.fill"
    case "Teamwork": return "person.3.fill"
    case "Respect": return "hand.raised.fill"
    default: return "star.fill"
    }
}

#Preview {
    StoryBuilderView()
}
