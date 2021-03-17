//
//  File.swift
//  
//
//  Created by Martin Lukacs on 17/03/2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}
