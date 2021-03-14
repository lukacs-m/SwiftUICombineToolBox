//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import SwiftUI

/**
 Wrapper to lazy load views when using programmatic navigation in swiftUI
 
 ### Usage Example: ###
 ````
 NavigationLink(destination: LazyView(Text("Place the view to be lazy loaded")),
                       tag: 1, selection: $navigationAction) {
     EmptyView().frame(width: 0, height: 0)
 }
 ````
 */
public struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
