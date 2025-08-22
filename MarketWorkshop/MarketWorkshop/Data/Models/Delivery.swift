import Foundation

struct Delivery: Codable {
    let provider: String?
    let options: [DeliveryOption]?
}
