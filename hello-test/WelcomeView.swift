import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignUp = false
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.15), Color.white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .foregroundColor(Color.purple.opacity(0.8))
                        Text("StoryTime")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(Color.purple)
                    }
                    Spacer()
                    NavigationLink(destination: StoryBuilderView()) {
                        Text("Start a Story")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: Color.purple.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 36)
                    Spacer()
                }
                .padding(.vertical, 32)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
