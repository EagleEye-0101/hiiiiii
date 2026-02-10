//
//  JourneyPhase.swift
//  SeeItLikeMe
//
//  Created by Teacher on 10/02/2026.
//


import SwiftUI

enum JourneyPhase {
    case orientation
    case shift
    case immersive
    case integration
}

struct ExperienceJourneyWrapper: View {
    let kind: ExperienceKind
    @EnvironmentObject var store: AppStore
    @State private var phase: JourneyPhase = .orientation
    @State private var progress: Double = 0.0 // 0 to 1
    
    var body: some View {
        ZStack {
            // The Experience Content
            ExperienceContent(kind: kind, phase: phase, progress: progress)
                .blur(radius: phase == .orientation ? 10 : 0)
                .opacity(phase == .orientation ? 0.3 : 1.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // Phase Overlays
            if phase == .orientation {
                VStack(spacing: 20) {
                    Text(kind.rawValue)
                        .font(.title.weight(.light))
                    Text(orientationText(for: kind))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(0.7)
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            if phase == .integration {
                VStack {
                    Spacer()
                    Text(reflectionText(for: kind))
                        .font(.body.italic())
                        .multilineTextAlignment(.center)
                        .padding(40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Back Button - Fixed Top-Left Safe Area
            VStack {
                HStack {
                    BackButton {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            store.flow = .hub
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            startJourney()
        }
    }
    
    private func startJourney() {
        // Phase 1: Orientation (5s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 2.0)) {
                phase = .shift
            }
            // Phase 2: Shift (15s)
            withAnimation(.linear(duration: 15.0)) {
                progress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersive
                    store.hubState = .immersed(kind)
                }
                
                // Phase 3: Immersive (15s)
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        phase = .integration
                        store.hubState = .integrating(kind)
                    }
                }
            }
        }
    }
    
    private func orientationText(for kind: ExperienceKind) -> String {
        switch kind {
        case .visualStrain: return "Notice how clarity is often a privilege of high contrast and clean space."
        case .colorPerception: return "Observe how meaning can be lost when color becomes the only messenger."
        case .focusTunnel: return "Feel the narrowing of attention as the periphery fades away."
        case .readingStability: return "Experience the effort of anchoring focus on shifting lines."
        case .memoryLoad: return "Witness the fragility of patterns under the weight of distraction."
        case .focusDistraction: return "Observe the quiet competition between intent and noise."
        case .cognitiveLoad: return "Feel the build of mental density as instructions multiply."
        case .interactionPrecision: return "Notice the subtle drift between intent and interaction."
        }
    }
    
    private func reflectionText(for kind: ExperienceKind) -> String {
        switch kind {
        case .visualStrain: return "When UI density exceeds comfort, focus becomes fatigue."
        case .colorPerception: return "True accessibility relies on more than just hue."
        case .focusTunnel: return "Context is easily lost when the viewport of attention narrows."
        case .readingStability: return "Stability is the foundation of comprehension."
        case .memoryLoad: return "Retention is a finite resource in a cluttered environment."
        case .focusDistraction: return "Motion commands attention; use it with intention."
        case .cognitiveLoad: return "Simplicity is not a lack of complexity, but a mastery of it."
        case .interactionPrecision: return "Precision is a dialogue between the user and the system."
        }
    }
}

struct ExperienceContent: View {
    let kind: ExperienceKind
    let phase: JourneyPhase
    let progress: Double
    
    var body: some View {
        Group {
            switch kind {
            case .visualStrain: VisualStrainExperience(progress: progress)
            case .colorPerception: ColorPerceptionExperience(progress: progress)
            case .focusTunnel: FocusTunnelExperience(progress: progress)
            case .readingStability: ReadingStabilityExperience(progress: progress)
            case .memoryLoad: MemoryLoadExperience(progress: progress)
            case .focusDistraction: FocusDistractionExperience(progress: progress)
            case .cognitiveLoad: CognitiveLoadExperience(progress: progress)
            case .interactionPrecision: InteractionPrecisionExperience(progress: progress)
            }
        }
    }
}

// --- Experience Implementations ---

struct VisualStrainExperience: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<15) { _ in
                HStack {
                    ForEach(0..<10) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.primary.opacity(0.1 + (progress * 0.4)))
                            .frame(width: 40 + (progress * 20), height: 20 + (progress * 10))
                    }
                }
            }
        }
        .opacity(1.0 - (progress * 0.5))
        .blur(radius: progress * 2)
        .brightness(progress * 0.2)
    }
}

struct ColorPerceptionExperience: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 30) {
                statusCircle(color: .red)
                statusCircle(color: .green)
                statusCircle(color: .blue)
            }
            
            Text("Select the primary action")
                .font(.headline)
                .foregroundColor(Color.primary.opacity(0.8))
        }
    }
    
    func statusCircle(color: Color) -> some View {
        Circle()
            .fill(color.opacity(1.0 - (progress * 0.8)))
            .overlay(Circle().stroke(Color.primary.opacity(progress), lineWidth: 1))
            .frame(width: 100, height: 100)
    }
}

struct FocusTunnelExperience: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background Content
            VStack(spacing: 20) {
                ForEach(0..<20) { _ in
                    Text("Important contextual information that provides meaning to the current task.")
                        .font(.caption)
                        .opacity(0.3)
                }
            }
            
            // Focus Window Mask
            GeometryReader { geo in
                RadialGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    center: .center,
                    startRadius: 100 - (progress * 80),
                    endRadius: 400 - (progress * 300)
                )
                .ignoresSafeArea()
            }
        }
    }
}

struct ReadingStabilityExperience: View {
    let progress: Double
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<8) { i in
                Text("Continuous text requires a stable baseline. When elements shift, the cognitive cost of tracking increases significantly.")
                    .font(.title3)
                    .offset(x: i % 2 == 0 ? (progress * offset) : -(progress * offset))
            }
        }
        .padding(40)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                offset = 15
            }
        }
    }
}

struct MemoryLoadExperience: View {
    let progress: Double
    @State private var pattern: [Int] = (0..<9).map { _ in Int.random(in: 0...1) }
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(60)), count: 3)) {
                ForEach(0..<9) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(pattern[i] == 1 ? Color.primary : Color.primary.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .opacity(progress > 0.5 ? 0.1 : 1.0)
                        .blur(radius: progress > 0.7 ? 5 : 0)
                }
            }
            
            Text("Recall the pattern")
                .font(.caption)
                .opacity(progress > 0.5 ? 1.0 : 0)
        }
    }
}

struct FocusDistractionExperience: View {
    let progress: Double
    @State private var distract = false
    
    var body: some View {
        ZStack {
            Text("Focus on this core message")
                .font(.title2)
                .opacity(1.0 - (progress * 0.7))
            
            ForEach(0..<12) { i in
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .offset(x: distract ? CGFloat.random(in: -200...200) : 0, 
                            y: distract ? CGFloat.random(in: -400...400) : 0)
                    .opacity(progress)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                distract = true
            }
        }
    }
}

struct CognitiveLoadExperience: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<Int(5 + (progress * 15)), id: \.self) { i in
                HStack {
                    Image(systemName: "info.circle")
                    Text("Requirement #\(i): Ensure that all parameters are calibrated.")
                        .font(.system(size: 14 - (progress * 2)))
                }
                .padding(8)
                .background(Color.primary.opacity(0.05))
                .cornerRadius(4)
            }
        }
        .padding(20)
    }
}

struct InteractionPrecisionExperience: View {
    let progress: Double
    @State private var drift = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {}) {
                Circle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(width: 80 - (progress * 40), height: 80 - (progress * 40))
                    .overlay(Text("Tap").font(.caption))
            }
            .offset(x: drift ? (progress * 20) : 0, y: drift ? (progress * -20) : 0)
            
            Text("Targets are shrinking and shifting.")
                .font(.caption)
                .opacity(progress)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }
}
