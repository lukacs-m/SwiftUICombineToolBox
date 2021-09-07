//
//  File.swift
//  
//
//  Created by Martin Lukacs on 05/09/2021.
//

import Foundation
import XCTest
import Combine
@testable import SwiftUICombineToolBox

final class PublisherTests: XCTestCase {
    var cancelable: Cancellable?

    private var testSendingAJustPublisher: AnyPublisher<Bool, MockError> {
        .just(false)
    }
    
    func test_publisher_validation_shouldBeValid() {
        cancelable = testSendingAJustPublisher
            .validateOutput { output in
                guard !output else {
                    throw MockError.outputNotValid
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure:
                    XCTFail("Shouldn't fail because validation passed")
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, false, "The result of the type comparaison should be true")
            })
    }
    
    func test_publisher_validation_shouldFailOnValidation() {
        cancelable = testSendingAJustPublisher
            .validateOutput { output in
                guard output else {
                    throw MockError.outputNotValid
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    XCTAssertTrue(error is MockError, "This should be an error of type MockError")
                    guard let error = error as? MockError else {
                        return XCTFail("Shouldn't fail")
                    }
                    XCTAssertEqual(error, MockError.outputNotValid, "This should be an error of type outputNotValid")
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Shouldn't receive any value because the validation fails")
            })
    }
    
    func test_publisher_output_switchToResult_shouldBeValid() {
        cancelable = testSendingAJustPublisher
            .validateOutput { output in
                guard !output else {
                    throw MockError.outputNotValid
                }
            }
            .switchToResultOutput()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success(let output):
                    XCTAssertEqual(output, false, "The result of the type comparaison should be true")
                case .failure:
                    XCTFail("Shouldn't fail because validation passed")
                }
            }
    }
    
    func test_publisher_output_switchToResult_shouldFail() {
        cancelable = testSendingAJustPublisher
            .validateOutput { output in
                guard output else {
                    throw MockError.outputNotValid
                }
            }
            .switchToResultOutput()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    XCTFail("Shouldn't receive any value because the validation fails")
                case .failure(let error):
                    guard let error = error as? MockError else {
                        return XCTFail("This should be an error of type MockError")
                    }
                    XCTAssertEqual(error, MockError.outputNotValid, "This should be an error of type outputNotValid")
                }
            }
    }
}
