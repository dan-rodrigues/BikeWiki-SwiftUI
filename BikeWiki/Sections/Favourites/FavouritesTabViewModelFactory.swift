// FavouritesTabViewModelFactory.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import Combine

final class FavouritesTabViewModelFactory: ObservableObject {
    
    // In:
    @Published var selectedTab: TabSelection = .search
    @Published var displayedBikeIds: Set<Bike.ID> = []
    @Published var favouriteBikeIds: Set<Bike.ID> = []
    // Out:
    @Published private(set) var viewModel: BikeListView.ViewModel = .init(favouritesState: .idle)
    
    private let searchPerformer: SearchPerforming
    
    init(searchPerformer: SearchPerforming = MockSearchPerformer()) {
        self.searchPerformer = searchPerformer
        
        struct ScanState {
            
            let previousTab: TabSelection
            let tabChanged: Bool
            let favouriteBikeIds: Set<Bike.ID>
        }
        
        Publishers
            .CombineLatest($selectedTab, $favouriteBikeIds)
            .scan(ScanState(previousTab: selectedTab, tabChanged: false, favouriteBikeIds: favouriteBikeIds) ) { state, stream in
                let (currentTab, favouriteBikeIds) = stream
                
                return ScanState(
                    previousTab: currentTab,
                    tabChanged: currentTab != state.previousTab,
                    favouriteBikeIds: favouriteBikeIds
                )
            }
            .filter { $0.tabChanged }
            .map { $0.favouriteBikeIds }
            .assign(to: &$displayedBikeIds)
        
        $displayedBikeIds
            .map { ids -> AnyPublisher<SearchState, Never> in
                return self.searchPerformer
                    .search(withIds: ids)
                    .catch { error in
                        Just(.failed(error))
                    }
                    .replaceError(with: .failed(.unknownError))
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .combineLatest($favouriteBikeIds.map { $0.count } )
            .map { state, count in
                BikeListView.ViewModel(favouritesState: state, favouriteCount: count)
            }
            .assign(to: &$viewModel)
    }
}

private extension BikeListView.ViewModel {
    
    init(favouritesState: SearchState, favouriteCount: Int = 0) {
        switch favouritesState {
        case .loading(.all), .loading(.identifiers):
            self = .loading(description: "Loading your favourites…")
        case .loading(.prefix):
            self = .loading(description: "Searching…")
        case let .loaded(results) where results.bikes.isEmpty:
            self = .info("You don't have any favourite bikes")
        case let .loaded(results):
            self = .loaded(.init(header: "\(favouriteCount) favourites", bikes: results.bikes))
        case .idle:
            self = .loading(description: "Initializing…")
        case let .failed(error):
            self = .info("Error occurred: \(error.localizedDescription)")
        case .awaitingMoreInput:
            assertionFailure("unexpected .awaitingMoreInput state")
            self = .info("Internal error occurred")
        }
    }
}
