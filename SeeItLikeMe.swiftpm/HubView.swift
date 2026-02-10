//
//  HubView.swift
//  SeeItLikeMe
//
//  Created by Teacher on 10/02/2026.
//


import SwiftUI

struct HubView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        ZStack {
            // Ambient Hub Motion
            GeometryReader { geo in
                let size = geo.size
                
                ZStack {
                    ForEach(ExperienceKind.allCases) { kind in
                        ExperienceNode(kind: kind)
                            .position(position(for: kind, in: size))
                    }
                }
            }
            
            VStack {
                Text("Select a perspective to begin")
                    .font(.title3.weight(.light))
                    .opacity(store.hubState == .idle ? 0.6 : 0)
                    .padding(.top, 100)
                Spacer()
            }
        }
        .calmTransition()
    }
    
    private func position(for kind: ExperienceKind, in size: CGSize) -> CGPoint {
        let index = CGFloat(ExperienceKind.allCases.firstIndex(of: kind) ?? 0)
        let total = CGFloat(ExperienceKind.allCases.count)
        let angle = (index / total) * 2 * .pi
        let radius = min(size.width, size.height) * 0.3
        
        return CGPoint(
            x: size.width / 2 + cos(angle) * radius,
            y: size.height / 2 + sin(angle) * radius
        )
    }
}

struct ExperienceNode: View {
    let kind: ExperienceKind
    @EnvironmentObject var store: AppStore
    @State private var breath = false
    
    var isCompleted: Bool { store.completedExperiences.contains(kind) }
    var isFocused: Bool {
        if case .focused(let k) = store.hubState { return k == kind }
        return false
    }
    
    var body: some View {
        Button(action: {
            store.beginJourney(kind)
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isCompleted ? Color.green.opacity(0.3) : Color.primary.opacity(0.1), lineWidth: 1)
                        .frame(width: 80, height: 80)
                        .scaleEffect(breath ? 1.1 : 0.95)
                    
                    Image(systemName: kind.icon)
                        .font(.title)
                        .foregroundColor(isCompleted ? .green : .primary)
                        .opacity(isCompleted ? 0.8 : 0.6)
                }
                
                Text(kind.rawValue)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(.secondary)
                    .opacity(breath ? 0.8 : 0.4)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isFocused ? 1.2 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                breath = true
            }
        }
    }
}
