import XCTest
@testable import MarketWorkshop

final class ProductsPresenterTests: XCTestCase {
    func makePresenter(repo: MockProductsRepository) -> (ProductsPresenter, MockProductsView) {
        let service = ProductsService(repository: repo)
        let presenter = ProductsPresenter(service: service)
        let view = MockProductsView()
        presenter.view = view
        return (presenter, view)
    }

    func testPresenterShowsProductsAfterLoad() {
        let repo = MockProductsRepository()
        repo.pages[1] = ProductListResponse(
            products: [makeProduct(id: "test1"), makeProduct(id: "test2")],
            currentPage: 1,
            hasMore: false
        )
        let (presenter, view) = makePresenter(repo: repo)

        let exp = expectation(description: "products shown to view")
        view.showProductsExpectation = exp
        presenter.loadProducts(refresh: true)
        wait(for: [exp], timeout: 2.0)

        let hasShowProducts = view.events.contains {
            if case .showProducts(let count) = $0, count == 2 { return true } 
            return false 
        }
        XCTAssertTrue(hasShowProducts, "Products should be shown to view")
    }

    func testPresenterHandlesErrorsGracefully() {
        let repo = MockProductsRepository()
        repo.shouldThrowError = true
        let (presenter, view) = makePresenter(repo: repo)

        let exp = expectation(description: "error handled")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            exp.fulfill()
        }
        
        presenter.loadProducts(refresh: true)
        wait(for: [exp], timeout: 2.0)

        let hasError = view.events.contains {
            if case .showError = $0 { return true } 
            return false 
        }
        XCTAssertTrue(hasError, "Error should be shown to view")
    }
}


