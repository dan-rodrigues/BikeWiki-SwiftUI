// MockSearchPerformer.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import Combine

struct MockSearchPerformer: SearchPerforming {

    private let bikes: [Bike]
    private let minLength: Int
    private let requestDelay: TimeInterval

    init(minLength: Int = 3, requestDelay: TimeInterval = 0.5, bikes: [Bike] = MockBikeCatalog.bikes) {
        self.minLength = minLength
        self.bikes = bikes
        self.requestDelay = requestDelay
    }
    
    func search(withPrefix prefix: String) -> AnyPublisher<SearchState, SearchError> {
        guard prefix.count >= self.minLength else {
            return Just(.awaitingMoreInput)
                .setFailureType(to: SearchError.self)
                .eraseToAnyPublisher()
        }
        
        let matchingBikes = bikes.filter { bike in
            return [bike.name, bike.manufacturer.name]
                .map { $0.lowercased() }
                .contains { $0.contains(prefix.lowercased()) }
        }
        
        return Just(matchingBikes)
            .delay(for: .seconds(requestDelay), scheduler: DispatchQueue.main)
            .setFailureType(to: SearchError.self)
            .map { autocompleteResults in
                .loaded(.init(searchType: .prefix(originalSearch: prefix), bikes: autocompleteResults))
            }
            .prepend(.loading(.prefix(originalSearch: prefix)))
            .eraseToAnyPublisher()
    }

    func search(withIds bikeIds: Set<Bike.ID>) -> AnyPublisher<SearchState, SearchError> {
        return self.fetchEntireCatalog()
            .map { state -> SearchState in
                switch state {
                case let .loaded(results):
                    return .loaded(.init(searchType: .all, bikes: bikeIds.compactMap { id in
                        results.bikes.first { $0.id == id }
                    }))
                default:
                    return state
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchEntireCatalog() -> AnyPublisher<SearchState, SearchError> {
        return Just(.loaded(.init(searchType: .all, bikes: bikes)))
            .delay(for: .seconds(requestDelay), scheduler: DispatchQueue.main)
            .prepend(.loading(.all))
            .setFailureType(to: SearchError.self)
            .eraseToAnyPublisher()
    }
}
