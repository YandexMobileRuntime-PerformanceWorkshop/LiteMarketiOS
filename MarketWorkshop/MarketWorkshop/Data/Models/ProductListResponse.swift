import Foundation

// MARK: - Product List Response
struct ProductListResponse: Codable {
    let products: [Product]
    let currentPage: Int
    let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case products
        case currentPage = "current_page"
        case hasMore = "has_more"
    }
} 
