import Foundation

// MARK: - Response Decoder Base Class
class ResponseDecoder<T> {
    
    init() {}
    
    func decode(_ data: Data) throws -> T {
        fatalError("decode(_:) must be implemented by subclass")
    }
}

// MARK: - Generic Codable Decoder
class CodableResponseDecoder<T: Codable>: ResponseDecoder<T> {
    
    override func decode(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - Product List Response Decoder
class ProductListResponseDecoder: ResponseDecoder<ProductListResponse> {
    
    override func decode(_ data: Data) throws -> ProductListResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(ProductListResponse.self, from: data)
    }
}

// MARK: - Single Product Decoder  
class ProductDecoder: ResponseDecoder<Product> {
    
    override func decode(_ data: Data) throws -> Product {
        let decoder = JSONDecoder()
        return try decoder.decode(Product.self, from: data)
    }
}

// MARK: - Product Detail Response
struct ProductDetailResponse: Codable {
    let product: Product
    let status: String
}

// MARK: - Product Detail Response Decoder
class ProductDetailResponseDecoder: ResponseDecoder<ProductDetailResponse> {
    
    override func decode(_ data: Data) throws -> ProductDetailResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(ProductDetailResponse.self, from: data)
    }
}

// MARK: - Prewarm Response Model
struct PrewarmResponse: Codable {
    let success: Bool
    let statusCode: Int
    let responseTime: TimeInterval
    
    init(success: Bool, statusCode: Int, responseTime: TimeInterval) {
        self.success = success
        self.statusCode = statusCode
        self.responseTime = responseTime
    }
}

// MARK: - Prewarm Response Decoder
final class PrewarmResponseDecoder: ResponseDecoder<PrewarmResponse> {
    
    override func decode(_ data: Data) throws -> PrewarmResponse {
        return PrewarmResponse(
            success: true,
            statusCode: 200,
            responseTime: 0.0
        )
    }
} 
