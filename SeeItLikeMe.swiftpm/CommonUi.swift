//
//  AmbientBackground.swift
//  SeeItLikeMe
//
//  Created by Teacher on 10/02/2026.
//


import SwiftUI

struct AmbientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(uiColor: .systemBackground),
                    Color(uiColor: .secondarySystemBackground),
                    Color(uiColor: .systemBackground).opacity(0.8)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 25.0).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
            
            // Subtle floating blobs
            GeometryReader { geo in
                ZStack {
                    Blob(color: .blue.opacity(0.05), size: 400)
                        .offset(x: animate ? 100 : -100, y: animate ? -50 : 50)
                    Blob(color: .purple.opacity(0.05), size: 300)
                        .offset(x: animate ? -150 : 150, y: animate ? 100 : -100)
                }
                .blur(radius: 80)
            }
        }
    }
}

struct Blob: View {
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
    }
}

extension View {
    func calmTransition() -> some View {
        self.transition(.opacity.combined(with: .scale(scale: 0.98)).animation(.easeInOut(duration: 1.0)))
    }
}

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding(.leading, 20)
        .padding(.top, 20)
    }
}
