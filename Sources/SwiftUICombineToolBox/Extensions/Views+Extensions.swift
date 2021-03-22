//
//  File.swift
//  
//
//  Created by Martin Lukacs on 17/03/2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder public func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
    
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    public func embedInLazyView() -> some View {
        LazyView(self)
    }
    
    public func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
