//
//  File.swift
//  
//
//  Created by Martin Lukacs on 17/03/2021.
//

import SwiftUI

// MARK: - View formatting helper functions
extension View {
    
    /// Hides elements of a View based on a boolean status
    /// - Parameter shouldHide: A boolean that indicated if the element should be hidden or not
    /// - Returns: A View hidden or not
    @ViewBuilder public func hide(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// Create a View taht takes the full space
    /// - Parameter alignment: The current allignment of the View
    /// - Returns: A View with infinite frame
    public func fullSize(alignment: Alignment = .center) -> some View {
        self.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: alignment
        )
    }
}

// MARK: - View syntactic helpers

extension View {
    
    /// Helper function enabeling us to easaly return an AnyView from any type of Views
    /// - Returns: A View typed erase to an AnyView
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    /// Helper function that embeds a View into a Navigation View
    /// - Returns: A NavigationView containing the current view
    public func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
