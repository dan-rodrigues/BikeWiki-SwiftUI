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
        let expectation = XCTestExpectation(description: "prompted for more input")
          
        factory.$viewModel.sink { viewModel in
            switch viewModel {
            case .info("Please enter more text to search"):
                expectation.fulfill()
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        factory.autocompleteInput = "a"
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNoInputProvided() {
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectation = XCTestExpectation(description: "loaded complete catalog")
          
        factory.$viewModel.sink { viewModel in
            switch viewModel {
            case let .loaded(results) where results.bikes.count == MockBikeCatalog.bikes.count:
                expectation.fulfill()
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        factory.autocompleteInput = ""
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testValidInputProvided() {
        let searchString = "Hon"
        
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectation = XCTestExpectation(description: "loaded Honda bikes only")
        let expectedBikes = MockBikeCatalog.bikes.filter { $0.manufacturer.name.contains(searchString) }
          
        factory.$viewModel.sink { viewModel in
            switch viewModel {
            case let .loaded(results) where results.bikes == expectedBikes:
                expectation.fulfill()
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        factory.autocompleteInput = searchString
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testValidLongerInputProvided() {
        let searchString = "Speed Triple"
        
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectation = XCTestExpectation(description: "loaded Speed Triple only")
        let expectedBikes = MockBikeCatalog.bikes.filter { $0.name.contains(searchString) }
          
        factory.$viewModel.sink { viewModel in
            switch viewModel {
            case let .loaded(results) where results.bikes == expectedBikes:
                expectation.fulfill()
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        factory.autocompleteInput = searchString
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMismatchedInputProvided() {
        let factory = SearchTabViewModelFactory(searchPerformer: mockPerformer)
        let expectation = XCTestExpectation(description: "loaded no bikes")
          
        factory.$viewModel.sink { viewModel in
            switch viewModel {
            case .info("No results found for your search"):
                expectation.fulfill()
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        factory.autocompleteInput = "SpeedTripleXYZ"
        wait(for: [expectation], timeout: 1.0)
    }
}
