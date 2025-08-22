import Foundation

struct PromoCode: Codable {
    let code: String?
    let discount: String?
    let minOrder: String?
    let expiryDate: String?
}
