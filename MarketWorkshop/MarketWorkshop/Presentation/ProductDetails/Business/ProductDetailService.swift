import Foundation

// MARK: - Service Protocol
protocol ProductDetailServiceProtocol {
    func getProductDetail(id: String) async throws -> ProductDetail
    func toggleFavorite(for productDetail: ProductDetail) -> ProductDetail
}

// MARK: - Service Implementation
final class ProductDetailService: ProductDetailServiceProtocol {
    private let repository: ProductDetailRepositoryProtocol
    
    init(repository: ProductDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func getProductDetail(id: String) async throws -> ProductDetail {
        let product = try await repository.fetchProductDetail(id: id)
        return convertToProductDetail(product)
    }
    
    func toggleFavorite(for productDetail: ProductDetail) -> ProductDetail {
        return ProductDetail(
            id: productDetail.id,
            title: productDetail.title,
            price: productDetail.price,
            images: productDetail.images,
            rating: productDetail.rating,
            isFavorite: !productDetail.isFavorite,
            manufacturer: productDetail.manufacturer,
            promoCode: productDetail.promoCode,
            delivery: productDetail.delivery,
            seller: productDetail.seller
        )
    }
}

// MARK: - Private Methods
private extension ProductDetailService {
    func convertToProductDetail(_ product: Product) -> ProductDetail {
        return ProductDetail(
            id: product.id,
            title: product.title,
            price: createPricing(from: product),
            images: product.pictureUrls,
            rating: createRating(from: product.rating),
            isFavorite: product.isFavorite,
            manufacturer: createManufacturer(from: product),
            promoCode: createPromoCode(from: product.promoCode),
            delivery: createDelivery(from: product.delivery),
            seller: createSeller(from: product)
        )
    }
    
    func createPricing(from product: Product) -> ProductDetail.Pricing {
        return ProductDetail.Pricing(
            currentPrice: product.currentPrice ?? product.price,
            oldPrice: product.oldPrice,
            discountPercentage: product.discountPercent.map { "\($0)%" },
            paymentMethod: "₽/мес с карты любого банка",
            alternativePrice: nil
        )
    }
    
    func createRating(from rating: Rating?) -> ProductDetail.Rating {
        return ProductDetail.Rating(
            score: rating?.score ?? 0.0,
            reviewsCount: rating?.reviewsCount ?? 0
        )
    }
    
    func createManufacturer(from product: Product) -> ProductDetail.Manufacturer {
        return ProductDetail.Manufacturer(
            name: product.vendor ?? "Unknown",
            badge: "Аутентичность подтверждена",
            isOriginal: true
        )
    }
    
    func createPromoCode(from promoCode: PromoCode?) -> ProductDetail.PromoCode? {
        guard let promo = promoCode else { return nil }
        
        return ProductDetail.PromoCode(
            code: promo.code ?? "Промокод",
            discount: promo.discount ?? "",
            minOrder: promo.minOrder,
            expiryDate: promo.expiryDate
        )
    }
    
    func createDelivery(from delivery: Delivery?) -> ProductDetail.Delivery {
        guard let delivery = delivery else {
            return ProductDetail.Delivery(provider: "Доставка", options: [])
        }
        
        let options = delivery.options?.compactMap { option in
            ProductDetail.DeliveryOption(
                type: option.type ?? "",
                date: option.date ?? "",
                details: option.details ?? "",
                isSelected: option.isSelected ?? false
            )
        } ?? []
        
        return ProductDetail.Delivery(
            provider: delivery.provider ?? "Доставка",
            options: options
        )
    }
    
    func createSeller(from product: Product) -> ProductDetail.Seller {
        return ProductDetail.Seller(
            name: product.shopName ?? "Магазин",
            logo: "shop",
            rating: 4.5,
            reviewsCount: "Отзывы",
            isFavorite: false
        )
    }
}


