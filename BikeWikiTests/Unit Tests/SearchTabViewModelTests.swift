// SearchTabViewModelTests.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import XCTest
import Combine
@testable import BikeWiki

class SearchTabViewModelTests: XCTestCase {

    private let mockPerformer = MockSearchPerformer(requestDelay: 0.0)
    private var cancellables: Set<AnyCancellable> = []
    
    func testMoreInputRequired() {
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        
        factory.$viewModel
            .expect(.info("Please enter more text to search"),
                    expectation: expectation(description: "prompted for more text"))
            .store(in: &cancellables)
        
        factory.autocompleteInput = "a"
        waitForExpectations(timeout: 1.0)
    }
    
    func testNoInputProvided() {
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        
        factory.$viewModel
            .expect(.loaded(.init(bikes: MockBikeCatalog.bikes)),
                    expectation: expectation(description: "prompted for more text"))
            .store(in: &cancellables)
        
        factory.autocompleteInput = ""
        waitForExpectations(timeout: 1.0)
    }
    
    func testValidInputProvided() {
        let searchString = "Hon"
        
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectedBikes = MockBikeCatalog.bikes.filter { $0.manufacturer.name.contains(searchString) }
          
        factory.$viewModel
            .expect({ $0.isLoaded(with: expectedBikes) },
                    expectation: expectation(description: "loaded Honda bikes only"))
            .store(in: &cancellables)
        
        factory.autocompleteInput = searchString
        waitForExpectations(timeout: 1.0)
    }
    
    func testValidLongerInputProvided() {
        let searchString = "Speed Triple"
        
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectedBikes = MockBikeCatalog.bikes.filter { $0.name.contains(searchString) }
          
        factory.$viewModel
            .expect({ $0.isLoaded(with: expectedBikes) },
                    expectation: expectation(description: "loaded Speed Triple only"))
            .store(in: &cancellables)
        
        factory.autocompleteInput = searchString
        waitForExpectations(timeout: 1.0)
    }
    
    func testMismatchedInputProvided() {
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
          
        factory.$viewModel
            .expect(.info("No results found for your search"),
                    expectation: expectation(description: "loaded no bikes"))
            .store(in: &cancellables)
        
        factory.autocompleteInput = "SpeedTripleXYZ"
        waitForExpectations(timeout: 1.0)
    }
}

// The Equatable conformance of LocalizedStringKey has unexpected behaviour
// If string interpolation is used, even an identical LocalizedStringKey isn't considered Equal
// See https://gist.github.com/mbrandonw/fd78446ec6e43fb316684f8a71c2bd34#fb7828757

private extension BikeListView.ViewModel {
    
    func isLoaded(with expectedBikes: [Bike]) -> Bool {
        switch self {
        case let .loaded(results) where results.bikes == expectedBikes:
            return true
        default:
            return false
        }
    }
}
