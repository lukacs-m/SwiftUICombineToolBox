//
//  File.swift
//  
//
//  Created by Martin Lukacs on 17/03/2021.
//

import SwiftUI

extension View {
    
    /// Helps hidding elements of a View based on a boolean status
    /// - Parameter shouldHide: A boolean that indicated if the element should be hidden or not
    /// - Returns: A View hidden or not
    @ViewBuilder public func hide(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// Helper function that embeds the current View into a LazyView
    /// - Returns: A LazyView containing current View 
    @ViewBuilder public func embedInLazyView() -> some View {
        LazyView(self)
    }
    
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
