import SwiftUI

struct BottomDock: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        HStack(spacing: 24) {
            // Context Indicator
            HStack(spacing: 8) {
                Image(systemName: currentIcon)
                    .font(.subheadline)
                Text(currentLabel)
                    .font(.caption.weight(.medium))
            }
            .frame(width: 140, alignment: .leading)
            .foregroundColor(.secondary)
            
            Spacer()
            
            // Visual Progress Indicator (Implicit)
            HStack(spacing: 4) {
                ForEach(0..<ExperienceKind.allCases.count, id: \.self) { i in
                    Circle()
                        .fill(i < store.completedExperiences.count ? Color.primary : Color.primary.opacity(0.1))
                        .frame(width: 4, height: 4)
                }
            }
            
            Spacer()
            
            // Reflect Button
            Button(action: {
                if case .integrating(let kind) = store.hubState {
                    store.finishJourney(kind)
                }
            }) {
                Text("Reflect")
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.primary.opacity(isReflectEnabled ? 0.1 : 0.05)))
                    .foregroundColor(isReflectEnabled ? .primary : .secondary.opacity(0.3))
            }
            .disabled(!isReflectEnabled)
            
            // Shift Perspective
            Image(systemName: "Circle.hexagongrid")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    private var currentIcon: String {
        switch store.flow {
        case .hub: return "square.grid.2x2"
        case .journey(let kind): return kind.icon
        case .synthesis: return "sparkles"
        default: return "circle"
        }
    }
    
    private var currentLabel: String {
        switch store.flow {
        case .hub: return "The Hub"
        case .journey(let kind): return kind.rawValue
        case .synthesis: return "Synthesis"
        default: return ""
        }
    }
    
    private var isReflectEnabled: Bool {
        if case .integrating = store.hubState { return true }
        return false
    }
}
