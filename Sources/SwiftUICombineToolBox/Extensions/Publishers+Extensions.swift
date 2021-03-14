//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Combine

extension Publisher where Self.Failure == Never {
    func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath< Root, Self.Output >,
                              on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}
