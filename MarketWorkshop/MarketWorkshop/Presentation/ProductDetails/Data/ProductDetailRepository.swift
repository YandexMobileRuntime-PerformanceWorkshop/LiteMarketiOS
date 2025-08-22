import Foundation

// MARK: - Repository Protocol
protocol ProductDetailRepositoryProtocol {
    func fetchProductDetail(id: String) async throws -> Product
}

// MARK: - Repository Implementation
final class ProductDetailRepository: ProductDetailRepositoryProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchProductDetail(id: String) async throws -> Product {
        let response = try await apiClient.request(route: ProductRoutes.getProductDetail(id: id))
        return response.product
    }
}


