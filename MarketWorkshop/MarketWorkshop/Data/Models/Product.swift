import Foundation

// MARK: - Product Model
struct Product: Codable {
    let id: String
    let title: String
    let currentPrice: String?
    let legacyPrice: String?
    let oldPrice: String?
    let discountPercent: Int?
    let pictureUrls: [String]
    let vendor: String?
    let shopName: String?
    let delivery: Delivery?
    let promoCode: PromoCode?
    let rating: Rating?
    let isFavorite: Bool
    
    var url: String? {
        return pictureUrls.first
    }
    
    var price: String {
        return currentPrice ?? legacyPrice ?? "Price not available"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case currentPrice = "current_price"
        case legacyPrice = "price"
        case oldPrice = "old_price"
        case discountPercent = "discount_percent"
        case pictureUrls = "picture_urls"
        case vendor
        case shopName = "shop_name"
        case delivery
        case promoCode
        case rating
        case isFavorite
    }
} 
