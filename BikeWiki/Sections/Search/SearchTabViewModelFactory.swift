// SearchTabViewModelFactory.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import Combine

final class SearchTabViewModelFactory: ObservableObject {
    
    // In:
    @Published var autocompleteInput: String = ""
    // Out:
    @Published private(set) var viewModel: BikeListView.ViewModel = .init(searchState: .idle)
    
    private let searchPerformer: SearchPerforming
    
    init(debounceInterval: TimeInterval = 0.3, searchPerformer: SearchPerforming = MockSearchPerformer()) {
        self.searchPerformer = searchPerformer
        
        // Note the merge() after the debounce()
        // This allows empty strings to "jump the queue" as it needs to clear the
        // screen immediately.
        let autocompleteResults = $autocompleteInput
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .merge(with: $autocompleteInput.filter { $0.isEmpty })
            .removeDuplicates()
            .map { input -> AnyPublisher<SearchState, Never> in
                if input.isEmpty {
                    return self.searchPerformer
                        .fetchEntireCatalog()
                        .catch { error in
                            Just(.failed(error))
                        }
                        .replaceError(with: .failed(.unknownError))
                        .eraseToAnyPublisher()
                } else {
                    return self.searchPerformer
                        .search(withPrefix: input)
                        .replaceError(with: .failed(.unknownError))
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
        
        autocompleteResults
            .map { .init(searchState: $0) }
            .assign(to: &$viewModel)
    }
}

private extension BikeListView.ViewModel {
    
    init(searchState: SearchState) {
        switch searchState {
        case .loading(.all):
            self = .loading(description: "Loading all bikes…")
        case .loading(.prefix), .loading(.identifiers):
            self = .loading(description: "Searching…")
        case let .loaded(results) where results.bikes.isEmpty:
            self = .info("No results found for your search")
        case let .loaded(results):
            switch results.searchType {
            case .all, .identifiers:
                self = .loaded(.init(header: nil, bikes: results.bikes))
            case let .prefix(originalSearch):
                self = .loaded(.init(header: "Results for search: \(originalSearch)", bikes: results.bikes))
            }
        case .awaitingMoreInput:
            self = .info("Please enter more text to search")
        case .idle:
            self = .loading(description: "Initializing…")
        case let .failed(error):
            self = .info("Error occurred: \(error.localizedDescription)")
        }
    }
}
