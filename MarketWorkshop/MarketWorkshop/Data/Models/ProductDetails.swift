struct ProductDetail {
    let id: String
    let title: String
    let price: Pricing
    let images: [String]
    let rating: Rating
    let isFavorite: Bool
    let manufacturer: Manufacturer
    let promoCode: PromoCode?
    let delivery: Delivery
    let seller: Seller

    struct Pricing {
        let currentPrice: String
        let oldPrice: String?
        let discountPercentage: String?
        let paymentMethod: String
        let alternativePrice: String?
    }

    struct Rating {
        let score: Double
        let reviewsCount: Int
    }

    struct PromoCode {
        let code: String
        let discount: String
        let minOrder: String?
        let expiryDate: String?
    }

    struct Manufacturer {
        let name: String
        let badge: String
        let isOriginal: Bool
    }

    struct Delivery {
        let provider: String
        let options: [DeliveryOption]
    }

    struct DeliveryOption {
        let type: String
        let date: String
        let details: String
        let isSelected: Bool
    }

    struct Seller {
        let name: String
        let logo: String
        let rating: Double
        let reviewsCount: String
        let isFavorite: Bool
    }
}
