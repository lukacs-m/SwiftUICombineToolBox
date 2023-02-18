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
    
    /**
     Allows writing sink without Task in a combine stream implementation
     
     - Example:  A little implementation
     ```swift
        $imageURL
        .compactMap({ $0 })
        .sink { [weak self] url in
            await self?.processImageURL(url)
        }
        .store(in: &cancellables)
     ```
     - Parameters:
        - validator: The validation callback
     - Returns: An AnyCancellable that should be store.
     */
    public func asyncSink(receiveValue: @escaping ((Output) async -> Void)) -> AnyCancellable {
        sink { value in
            Task {
                await receiveValue(value)
            }
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

extension Publisher {
    
    /// Helper to execute async work in a combine stream execution
    /// - Parameter transform: An async function
    /// - Returns: A publisher returnning the result of the above async fonction
    ///
    /// This comes from the following article by sundell [Calling async functions within a Combine pipeline](https://www.swiftbysundell.com/articles/calling-async-functions-within-a-combine-pipeline/)
    /// ```swift
    /// struct PhotoUploader {
    ///     var renderer: PhotoRenderer
    ///     var urlSession = URLSession.shared
    ///     func upload(_ photo: Photo,
    ///             to url: URL) -> AnyPublisher<URLResponse, Error> {
    ///         renderer
    ///             .render(photo)
    ///             .asyncMap { image in
    ///                 guard let data = image.pngData() else {
    ///                     throw PhotoUploadingError.invalidImage(image)
    ///                 }
    ///                 var request = URLRequest(url: url)
    ///                 request.httpMethod = "POST"
    ///                 let (_, response) = try await urlSession.upload(for: request, from: data)
    ///                 return response
    ///             }.eraseToAnyPublisher()
    ///     }
    ///}
    /// ```
    public func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>,
                            Publishers.SetFailureType<Self, Error>> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
    
    /// Helper to execute async work in a combine stream execution
    /// - Parameter transform: An async function
    /// - Returns: A publisher returnning the result of the above async fonction
    /// This comes from the following article [Calling async functions within a Combine pipeline](https://augmentedcode.io/2023/01/09/async-await-support-for-combines-sink-and-map/)
    /// - Example: A throwing downstream publisher
    /// ```swift
    ///    $imageURL
    ///    .tryMap({ try Self.validateURL($0) })
    ///   .tryAwaitMap({ try await ImageProcessor.process($0) })
    ///    .map({ Image(uiImage: $0) })
    ///   .sink(receiveCompletion: { print("completion: \($0)") },
    ///          receiveValue: { print($0) })
    ///   .store(in: &cancellables)
    /// ```

    public func tryAwaitMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let result = try await transform(value)
                        promise(.success(result))
                    }
                    catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
