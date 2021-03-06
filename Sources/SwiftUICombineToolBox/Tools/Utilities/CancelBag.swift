//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Combine

///Little typealias for a set of  AnyCancellable 
public typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
  mutating public func cancelAll() {
    forEach { $0.cancel() }
    removeAll()
  }
}
