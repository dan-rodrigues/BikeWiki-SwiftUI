import XCTest
import Combine
import SnapshotTesting
@testable import BikeWiki

class SearchTabViewSnapshotTests: XCTestCase {
    
    func testInfoDisplay() {
        let favourites = FavouritesStore()
        let view = SearchTabView(
            searchInput: .constant(""),
            viewModel: .info("(Placeholder info text)"),
            favourites: favourites
        )
        .colorScheme(.dark)
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testLoading() {
        let favourites = FavouritesStore()
        let view = SearchTabView(
            searchInput: .constant("(Search input)"),
            viewModel: .loading(description: "(Placeholder loading text)"),
            favourites: favourites
        )
        .colorScheme(.dark)
        
        assertSnapshot(matching: view, as: .image)
    }

    func testLoaded() {
        let favourites = FavouritesStore()
        let view = SearchTabView(
            searchInput: .constant("(Search input)"),
            viewModel: .loaded(.init(header: "(Header)", bikes: MockBikeCatalog.bikes)),
            favourites: favourites
        )
        .colorScheme(.dark)
        .environment(\.showPlaceholderImages, true)
        
        assertSnapshot(matching: view, as: .image)
    }
}
