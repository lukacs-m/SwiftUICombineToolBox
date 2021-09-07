//
//  File.swift
//  
//
//  Created by Martin Lukacs on 03/09/2021.
//

import Combine

// MARK: - Extensions linked to Combine Just Publisher
extension Just {
    
    /// Transforms a Just publisher into a Anypublisher
    /// - Parameter errorType: The type of error the AnyPublisher should return
    /// - Returns: An AnyPublisher that returns the output and specified error type
    public func switchToAnyPublisher<ReturnedError: Error>(with errorType: ReturnedError.Type) -> AnyPublisher<Output, ReturnedError> {
        self.setFailureType(to: errorType).eraseToAnyPublisher()
    }
}
