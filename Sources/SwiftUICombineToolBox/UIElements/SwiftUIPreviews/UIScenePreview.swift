//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import SwiftUI

public struct UIScenePreview<Value: View>: View {
    private let viewToPreview: Value

    public init(_ viewToPreview: Value) {
        self.viewToPreview = viewToPreview
    }

    public var body: some View {
        Group {
            self.viewToPreview
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
            
            self.viewToPreview
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")
        }
    }
}
