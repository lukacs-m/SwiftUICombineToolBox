//
//  File.swift
//  
//
//  Created by Martin Lukacs on 04/09/2021.
//

import XCTest
import Combine
@testable import SwiftUICombineToolBox

final class AnyPublisherTests: XCTestCase {
    var cancelable: Cancellable?
    
    private func testSendingAFailure() -> AnyPublisher<Bool, MockError> {
        .isFailing(with: MockError.testError)
    }
    
    private func testSendingAJustPublisher() -> AnyPublisher<Bool, MockError> {
        .just(true)
    }
    
    func test_anyPublisher_switchToFailure_shouldBeValid() {
        cancelable = testSendingAFailure()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    XCTAssertEqual(error, MockError.testError, "This should be a testError")
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                XCTFail("Should never receive a value. Should fail")
            })
    }
    
    func test_anyPublisher_switchToJustPublisher_shouldBeValid() {
        cancelable = testSendingAJustPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure:
                    XCTFail("Should never fail")
                case .finished:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, true, "This should be a boolean with a value of true")
            })
    }
}
