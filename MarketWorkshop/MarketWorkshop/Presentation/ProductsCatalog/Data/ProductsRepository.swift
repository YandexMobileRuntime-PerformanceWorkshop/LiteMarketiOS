import Foundation

// MARK: - Repository Protocol
protocol ProductsRepositoryProtocol {
    func fetchProducts(page: Int, perPage: Int) async throws -> ProductListResponse
}

// MARK: - Repository Implementation
final class ProductsRepository: ProductsRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchProducts(page: Int, perPage: Int) async throws -> ProductListResponse {
        return try await apiClient.request(route: ProductRoutes.getProductsList(page: page, perPage: perPage))
    }
}
