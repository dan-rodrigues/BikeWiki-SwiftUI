import XCTest
import Combine
@testable import BikeWiki

class SearchTabViewModelTests: XCTestCase {

    private let mockPerformer = MockSearchPerformer()
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // this would be needed by snapshot tests or where a View is needed, but not here
        // can just make the mock instances directly
//        ServiceProvider.shared.registerServices([
//            .init(service: SearchPerforming.self, factory: { _ in self.mockPerformer })
//        ])
    }
    
    func testMoreInputRequired() throws {
        let f = SearchTabViewModelFactory(autocompleteController: mockPerformer)
        
        let e = XCTestExpectation(description: "e")
          
        f.$viewModel.sink { vm in
            switch vm.presentation {
            case .search(.awaitingMoreInput):
                e.fulfill()
                break
            case .empty:
                break
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        f.autocompleteInput = "a"
        
        wait(for: [e], timeout: 3.0)
    }
}
