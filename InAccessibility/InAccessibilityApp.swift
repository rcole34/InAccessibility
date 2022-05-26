//
//  InAccessibilityApp.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import SwiftUI

@main
struct InAccessibilityApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

extension Color {
    static let secondaryTextA11y = Color("secondaryTextA11y")
    static let greenA11y = Color("greenA11y")
    static let redA11y = Color("redA11y")
}

/// ✅ audio graphs
/// ✅ accessibility elements for data points?
/// ✅ reduce animation on graph if preference set
