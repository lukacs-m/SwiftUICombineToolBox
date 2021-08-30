//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Combine

extension Publisher where Self.Failure == Never {
    /// This helps to assign a publisher to a object without creating a strong reference between the two.
    /// This removes the risk of creating a potential memory leak while using combine assign feature.
    /// - Parameters:
    ///   - keyPath: The keypath for the destination variable of the object
    ///   - object: The object containing the above keyPath
    /// - Returns: An AnyCancellable that should be store.
    public func weakAssign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
                                 on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Published.Publisher {
    public func collectNext(_ count: Int) -> AnyPublisher<[Output], Never> {
        self.dropFirst()
            .collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}

// MARK: - Extensions linked to Combine Just Publisher
extension Just {
    
    /// Transforms a Just publisher into a Anypublisher
    /// - Parameter errorType: The type of error the AnyPublisher should return
    /// - Returns: An AnyPublisher that returns the output and specified error type
    public func switchToAnyPublisher<ReturnedError: Error>(with errorType: ReturnedError.Type) -> AnyPublisher<Output, ReturnedError> {
        self.setFailureType(to: errorType).eraseToAnyPublisher()
    }
}
