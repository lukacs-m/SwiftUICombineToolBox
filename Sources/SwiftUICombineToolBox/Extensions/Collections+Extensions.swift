//
//  File.swift
//  
//
//  Created by Martin Lukacs on 17/03/2021.
//

import Foundation

extension RandomAccessCollection {
    public func indexed() -> Array<(offset: Int, element: Element)> {
        Array(enumerated())
    }
}
