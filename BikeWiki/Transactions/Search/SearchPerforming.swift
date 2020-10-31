// SearchState.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import Combine

enum SearchState {

    struct Results {

        let searchType: SearchType
        let bikes: [Bike]
    }
    
    enum SearchType: Equatable {
        
        case all
        case prefix(originalSearch: String)
        case identifiers(bikeIds: Set<Bike.ID>)
    }
    
    case idle
    case loading(SearchType)
    case awaitingMoreInput
    case loaded(Results)
    case failed(SearchError)
}

enum SearchError: Error {

    case failed(underlyingError: Error)
    case unknownError
    case cancelled
}

protocol SearchPerforming {

    func search(withPrefix prefix: String) -> AnyPublisher<SearchState, SearchError>
    func search(withIds bikeIds: Set<Bike.ID>) -> AnyPublisher<SearchState, SearchError>
    func fetchEntireCatalog() -> AnyPublisher<SearchState, SearchError>
}
