import Foundation
import XCTest
@testable import MarketWorkshop

// MARK: - Mock Repository
final class MockProductsRepository: ProductsRepositoryProtocol {
    var pages: [Int: ProductListResponse] = [:]
    var fetchCalls: [Int] = []
    var delayNanoseconds: UInt64 = 0
    var shouldThrowError = false

    func fetchProducts(page: Int, perPage: Int) async throws -> ProductListResponse {
        fetchCalls.append(page)
        if delayNanoseconds > 0 {
            try? await Task.sleep(nanoseconds: delayNanoseconds)
        }
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        if let response = pages[page] {
            return response
        }
        return ProductListResponse(products: [], currentPage: page, hasMore: false)
    }
}

// MARK: - Mock View
final class MockProductsView: ProductsView {
    enum Event: Equatable {
        case showLoading(Bool)
        case showPaginationLoading(Bool)
        case showProducts(count: Int)
        case showError
    }

    private(set) var events: [Event] = []
    var showProductsExpectation: XCTestExpectation?

    func show(products: [Product]) {
        events.append(.showProducts(count: products.count))
        showProductsExpectation?.fulfill()
    }

    func showError(_ error: Error) {
        events.append(.showError)
    }

    func showLoading(_ isLoading: Bool) {
        events.append(.showLoading(isLoading))
    }

    func showPaginationLoading(_ isLoading: Bool) {
        events.append(.showPaginationLoading(isLoading))
    }
}

// MARK: - Mock ProductDetail Repository
final class MockProductDetailRepository: ProductDetailRepositoryProtocol {
    var productDetails: [String: Product] = [:]
    var shouldThrowError = false
    
    func fetchProductDetail(id: String) async throws -> Product {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        if let product = productDetails[id] {
            return product
        }
        throw NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
    }
}

// MARK: - Mock ProductDetail View
final class MockProductDetailView: ProductDetailView {
    enum Event: Equatable {
        case displayLoading
        case displayProduct
        case displayError
    }
    
    private(set) var events: [Event] = []
    var displayProductExpectation: XCTestExpectation?
    var displayErrorExpectation: XCTestExpectation?
    
    func display(product: ProductDetail) {
        events.append(.displayProduct)
        displayProductExpectation?.fulfill()
    }
    
    func displayLoading() {
        events.append(.displayLoading)
    }
    
    func displayError(message: String) {
        events.append(.displayError)
        displayErrorExpectation?.fulfill()
    }
}

// MARK: - Test Helpers
func makeProduct(id: String, title: String? = nil) -> Product {
    return Product(
        id: id,
        title: title ?? "Title \(id)",
        currentPrice: "100",
        legacyPrice: nil,
        oldPrice: nil,
        discountPercent: nil,
        pictureUrls: ["https://example.com/\(id).png"],
        vendor: nil,
        shopName: nil,
        delivery: nil,
        promoCode: nil,
        rating: nil,
        isFavorite: false
    )
}


