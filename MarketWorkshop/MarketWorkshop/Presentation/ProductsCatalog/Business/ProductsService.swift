import Foundation

// MARK: - Service Protocol
protocol ProductsServiceProtocol {
    func loadProducts(refresh: Bool) async throws -> ProductsLoadResult
    func loadNextPageIfNeeded() async throws -> ProductsLoadResult
    func isCurrentlyLoading() -> Bool
}

// MARK: - Service Models
struct ProductsLoadResult {
    let products: [Product]
    let hasMorePages: Bool
    let isRefresh: Bool
}

// MARK: - Service Implementation
final class ProductsService: ProductsServiceProtocol {
    private let repository: ProductsRepositoryProtocol
    private var allProducts: [Product] = []
    private var currentPage = 1
    private var hasMorePages = true
    private var isLoading = false
    private let itemsPerPage = 100

    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadProducts(refresh: Bool) async throws -> ProductsLoadResult {
        guard !isLoading else { 
            return ProductsLoadResult(products: allProducts, hasMorePages: hasMorePages, isRefresh: refresh)
        }
        
        if refresh {
            resetPagination()
        }
        
        guard hasMorePages else {
            return ProductsLoadResult(products: allProducts, hasMorePages: false, isRefresh: refresh)
        }
        
        isLoading = true
        
        do {
            let response = try await repository.fetchProducts(page: currentPage, perPage: itemsPerPage)
            
            updateProductsState(with: response, isRefresh: refresh)
            isLoading = false
            
            return ProductsLoadResult(products: allProducts, hasMorePages: hasMorePages, isRefresh: refresh)
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func loadNextPageIfNeeded() async throws -> ProductsLoadResult {
        return try await loadProducts(refresh: false)
    }
    
    func isCurrentlyLoading() -> Bool {
        return isLoading
    }
}

// MARK: - Private Methods
private extension ProductsService {
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        allProducts.removeAll()
    }
    
    func updateProductsState(with response: ProductListResponse, isRefresh: Bool) {
        if isRefresh {
            allProducts = response.products
        } else {
            allProducts.append(contentsOf: response.products)
        }
        
        hasMorePages = response.hasMore
        currentPage += 1
    }
}
