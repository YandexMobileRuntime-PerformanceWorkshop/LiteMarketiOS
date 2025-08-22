import XCTest
@testable import MarketWorkshop

final class ProductsServiceTests: XCTestCase {
    func testLoadProductsReturnsCorrectData() async throws {
        let repo = MockProductsRepository()
        repo.pages[1] = ProductListResponse(
            products: [makeProduct(id: "product1"), makeProduct(id: "product2")],
            currentPage: 1,
            hasMore: true
        )
        let service = ProductsService(repository: repo)

        let result = try await service.loadProducts(refresh: true)

        XCTAssertEqual(result.products.count, 2)
        XCTAssertEqual(result.products[0].id, "product1")
        XCTAssertEqual(result.products[1].id, "product2")
        XCTAssertTrue(result.hasMorePages)
    }

    func testPaginationAccumulatesProducts() async throws {
        let repo = MockProductsRepository()
        repo.pages[1] = ProductListResponse(
            products: [makeProduct(id: "page1_item1"), makeProduct(id: "page1_item2")],
            currentPage: 1,
            hasMore: true
        )
        repo.pages[2] = ProductListResponse(
            products: [makeProduct(id: "page2_item1"), makeProduct(id: "page2_item2")],
            currentPage: 2,
            hasMore: false
        )
        let service = ProductsService(repository: repo)

        let _ = try await service.loadProducts(refresh: true)
        let result2 = try await service.loadProducts(refresh: false)

        // Test: Products from both pages are accumulated
        XCTAssertEqual(result2.products.count, 4)
        XCTAssertEqual(result2.products[0].id, "page1_item1")
        XCTAssertEqual(result2.products[2].id, "page2_item1")
        XCTAssertFalse(result2.hasMorePages)
    }

    func testRefreshResetsProducts() async throws {
        let repo = MockProductsRepository()
        repo.pages[1] = ProductListResponse(
            products: [makeProduct(id: "old1"), makeProduct(id: "old2")],
            currentPage: 1,
            hasMore: false
        )
        let service = ProductsService(repository: repo)

        _ = try await service.loadProducts(refresh: true)
        
        repo.pages[1] = ProductListResponse(
            products: [makeProduct(id: "new1"), makeProduct(id: "new2"), makeProduct(id: "new3")],
            currentPage: 1,
            hasMore: false
        )
        
        let result = try await service.loadProducts(refresh: true)

        XCTAssertEqual(result.products.count, 3)
        XCTAssertEqual(result.products[0].id, "new1")
        XCTAssertEqual(result.products[2].id, "new3")
    }

    func testErrorHandlingDoesntCrash() async {
        let repo = MockProductsRepository()
        repo.shouldThrowError = true
        let service = ProductsService(repository: repo)

        do {
            _ = try await service.loadProducts(refresh: true)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(true, "Error handled gracefully")
        }
        
        XCTAssertFalse(service.isCurrentlyLoading())
    }
}


