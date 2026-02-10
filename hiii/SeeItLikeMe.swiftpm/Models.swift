//
//  Models.swift
//  SeeItLikeMe
//
//  Created by student on 10/02/26.
//


//
//  AppFlow.swift
//  SeeItLikeMe
//
//  Created by Teacher on 10/02/2026.
//


import SwiftUI

enum AppFlow: Equatable {
    case onboarding
    case hub
    case journey(ExperienceKind)
    case synthesis
}

enum HubState: Equatable {
    case idle
    case focused(ExperienceKind)
    case immersed(ExperienceKind)
    case integrating(ExperienceKind)
}

enum ExperienceKind: String, CaseIterable, Identifiable {
    case visualStrain = "Visual Strain"
    case colorPerception = "Color Perception"
    case focusTunnel = "Focus Tunnel"
    case readingStability = "Reading Stability"
    case memoryLoad = "Memory Load"
    case focusDistraction = "Focus Distraction"
    case cognitiveLoad = "Cognitive Load"
    case interactionPrecision = "Interaction Precision"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .visualStrain: return "eye.trianglebadge.exclamationmark"
        case .colorPerception: return "paintpalette"
        case .focusTunnel: return "scope"
        case .readingStability: return "text.justify.left"
        case .memoryLoad: return "brain.head.profile"
        case .focusDistraction: return "bolt.ring.closed"
        case .cognitiveLoad: return "square.stack.3d.up"
        case .interactionPrecision: return "hand.tap"
        }
    }
}

class AppStore: ObservableObject {
    @Published var flow: AppFlow = .onboarding
    @Published var hubState: HubState = .idle
    @Published var completedExperiences: Set<ExperienceKind> = []
    @Published var showMenu: Bool = false
    
    func beginJourney(_ kind: ExperienceKind) {
        withAnimation(.easeInOut(duration: 1.0)) {
            flow = .journey(kind)
            hubState = .focused(kind)
        }
    }
    
    func finishJourney(_ kind: ExperienceKind) {
        completedExperiences.insert(kind)
        withAnimation(.easeInOut(duration: 1.2)) {
            if completedExperiences.count == ExperienceKind.allCases.count {
                flow = .synthesis
            } else {
                flow = .hub
                hubState = .idle
            }
        }
    }
}
