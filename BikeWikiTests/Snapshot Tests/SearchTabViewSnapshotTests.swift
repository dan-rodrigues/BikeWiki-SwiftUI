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
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testLoading() {
        let favourites = FavouritesStore()
        let view = SearchTabView(
            searchInput: .constant("(Search input)"),
            viewModel: .loading(description: "(Placeholder loading text)"),
            favourites: favourites
        )
        
        assertSnapshot(matching: view, as: .image)
    }
    
    func testLoaded() {
        let favourites = FavouritesStore()
        let view = SearchTabView(
            searchInput: .constant("(Search input)"),
            viewModel: .loaded(.init(header: "(Header)", bikes: MockBikeCatalog.bikes)),
            favourites: favourites
        )
        
        let loadExpectation = expectation(description: "images assumed to have loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        assertSnapshot(matching: view, as: .image)
    }
}
