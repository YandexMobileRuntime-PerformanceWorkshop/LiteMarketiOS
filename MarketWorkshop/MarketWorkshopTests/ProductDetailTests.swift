import XCTest
@testable import MarketWorkshop

final class ProductDetailTests: XCTestCase {
    
    // MARK: - Service Tests
    func testGetProductDetailReturnsCorrectData() async throws {
        let repo = MockProductDetailRepository()
        let testProduct = makeTestProduct(id: "test123")
        repo.productDetails["test123"] = testProduct
        
        let service = ProductDetailService(repository: repo)
        
        let result = try await service.getProductDetail(id: "test123")
        
        XCTAssertEqual(result.id, "test123")
        XCTAssertEqual(result.title, testProduct.title)
        XCTAssertEqual(result.price.currentPrice, testProduct.price)
        XCTAssertEqual(result.isFavorite, testProduct.isFavorite)
        XCTAssertEqual(result.images, testProduct.pictureUrls)
    }
    
    func testToggleFavoriteChangesState() async throws {
        let repo = MockProductDetailRepository()
        let testProduct = makeTestProduct(id: "test123", isFavorite: false)
        repo.productDetails["test123"] = testProduct
        
        let service = ProductDetailService(repository: repo)
        
        let originalDetail = try await service.getProductDetail(id: "test123")
        let toggledDetail = service.toggleFavorite(for: originalDetail)
        
        XCTAssertFalse(originalDetail.isFavorite)
        XCTAssertTrue(toggledDetail.isFavorite)
        XCTAssertEqual(originalDetail.id, toggledDetail.id)
        XCTAssertEqual(originalDetail.title, toggledDetail.title)
    }
    
    func testServiceHandlesErrorsGracefully() async {
        let repo = MockProductDetailRepository()
        repo.shouldThrowError = true
        
        let service = ProductDetailService(repository: repo)
        
        do {
            _ = try await service.getProductDetail(id: "nonexistent")
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(true, "Error handled gracefully")
        }
    }
    
    func testProductDetailConversionWithPromoCode() async throws {
        let repo = MockProductDetailRepository()
        let promoCode = PromoCode(
            code: "SAVE20",
            discount: "20%",
            minOrder: "1000₽",
            expiryDate: "31.12.2024"
        )
        let testProduct = makeTestProduct(id: "promo123", promoCode: promoCode)
        repo.productDetails["promo123"] = testProduct
        
        let service = ProductDetailService(repository: repo)
        let result = try await service.getProductDetail(id: "promo123")
        
        XCTAssertNotNil(result.promoCode)
        XCTAssertEqual(result.promoCode?.code, "SAVE20")
        XCTAssertEqual(result.promoCode?.discount, "20%")
    }
    
    // MARK: - Presenter Tests
    func testPresenterDisplaysProductAfterLoad() {
        let repo = MockProductDetailRepository()
        let testProduct = makeTestProduct(id: "presenter123")
        repo.productDetails["presenter123"] = testProduct
        
        let service = ProductDetailService(repository: repo)
        let mockAnalytics = MVIScreenAnalytics(creationTime: .fromScreenCreation(timestamp: .now()))
        let presenter = ProductDetailPresenter(
            service: service,
            productId: "presenter123",
            mviScreenAnalytics: mockAnalytics
        )
        let mockView = MockProductDetailView()
        presenter.view = mockView
        
        let exp = expectation(description: "product displayed")
        mockView.displayProductExpectation = exp
        presenter.viewDidLoad()
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertTrue(mockView.events.contains(.displayLoading))
        XCTAssertTrue(mockView.events.contains { 
            if case .displayProduct = $0 { return true }
            return false
        })
    }
    
    func testPresenterHandlesErrorsGracefully() {
        let repo = MockProductDetailRepository()
        repo.shouldThrowError = true
        
        let service = ProductDetailService(repository: repo)
        let mockAnalytics = MVIScreenAnalytics(creationTime: .fromScreenCreation(timestamp: .now()))
        let presenter = ProductDetailPresenter(
            service: service,
            productId: "error123",
            mviScreenAnalytics: mockAnalytics
        )
        let mockView = MockProductDetailView()
        presenter.view = mockView
        
        let exp = expectation(description: "error displayed")
        mockView.displayErrorExpectation = exp
        presenter.viewDidLoad()
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertTrue(mockView.events.contains(.displayLoading))
        XCTAssertTrue(mockView.events.contains { 
            if case .displayError = $0 { return true }
            return false
        })
    }
}

// MARK: - Test Helpers
private func makeTestProduct(
    id: String,
    title: String = "Test Product",
    isFavorite: Bool = false,
    promoCode: PromoCode? = nil
) -> Product {
    return Product(
        id: id,
        title: title,
        currentPrice: "1000₽",
        legacyPrice: nil,
        oldPrice: "1200₽",
        discountPercent: 20,
        pictureUrls: ["https://example.com/\(id).png"],
        vendor: "Test Vendor",
        shopName: "Test Shop",
        delivery: nil,
        promoCode: promoCode,
        rating: Rating(score: 4.5, reviewsCount: 100),
        isFavorite: isFavorite
    )
}
