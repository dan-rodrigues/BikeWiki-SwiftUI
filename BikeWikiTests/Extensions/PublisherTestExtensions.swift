// PublisherTestExtensions.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import XCTest
import Combine

extension Publisher where Output: Equatable, Failure == Never {

    func expect(_ value: Output, expectation: XCTestExpectation) -> AnyCancellable {
        return sink { output in
            if output == value {
                expectation.fulfill()
            }
        }
    }
    
    func expect(_ predicate: @escaping (Output) -> Bool, expectation: XCTestExpectation) -> AnyCancellable {
        return sink { output in
            if predicate(output) {
                expectation.fulfill()
            }
        }
    }
}
