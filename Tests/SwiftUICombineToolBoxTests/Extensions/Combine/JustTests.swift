//
//  JustTests.swift
//  
//
//  Created by Martin Lukacs on 04/09/2021.
//

import XCTest
import Combine
@testable import SwiftUICombineToolBox

final class JustTests: XCTestCase {
    func test_just_switchToAnyPublisher_shouldBeValid() {
        let justPublisher = Just(false)
        let sut = justPublisher.switchToAnyPublisher(with: MockError.self)
        let result = type(of: sut) is AnyPublisher<Bool, MockError>.Type
        
        XCTAssertTrue(result, "The result of the type comparaison should be true")
    }
}
