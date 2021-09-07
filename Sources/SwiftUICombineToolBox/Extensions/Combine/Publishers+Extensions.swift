//
//  File.swift
//  
//
//  Created by Martin Lukacs on 14/03/2021.
//

import Foundation
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

extension Publisher where Output == Data {
    /// Helper decode function that inferres the decoding type
    /// - Parameters:
    ///   - type: Type returned by the publisher. This type must conform to Decodable protocol.
    ///   - decoder: The Json Decoder to process the decoding
    /// - Returns: A publisher containing a value of the returnedType
    public func decode<ReturnType: Decodable>(as type: ReturnType.Type = ReturnType.self,
                                              using decoder: JSONDecoder = .init()) -> Publishers.Decode<Self, ReturnType, JSONDecoder> {
        decode(type: type, decoder: decoder)
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

extension Publisher {
    /// Helper function to be able to validate data in publisher stream
    /// - Parameter validator: The validation callback
    /// - Returns: The data or a throws a error if validation if not fullfilled
    public func validateOutput(
        using validator: @escaping (Output) throws -> Void
    ) -> Publishers.TryMap<Self, Output> {
        tryMap { output in
            try validator(output)
            return output
        }
    }
    
    /// Conversion from a failing publisher to a publisher containing a Result output
    /// - Returns: A result containing the output or a failure.
    public func switchToResultOutput() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
