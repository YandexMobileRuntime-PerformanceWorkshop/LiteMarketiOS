import Foundation

// MARK: - Presenter Protocol
protocol ProductDetailPresenterProtocol {
    var view: ProductDetailView? { get set }
    func viewDidLoad()
    func toggleFavorite()
    func logLCP()
}

// MARK: - Presenter Implementation
final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    weak var view: ProductDetailView?
    private let service: ProductDetailServiceProtocol
    private let productId: String
    private var productDetail: ProductDetail?
    private let mviScreenAnalytics: MVIScreenAnalytics

    init(
        service: ProductDetailServiceProtocol,
        productId: String,
        mviScreenAnalytics: MVIScreenAnalytics
    ) {
        self.service = service
        self.productId = productId
        self.mviScreenAnalytics = mviScreenAnalytics
    }

    func viewDidLoad() {
        view?.displayLoading()
        
        Task {
            do {
                let productDetail = try await service.getProductDetail(id: productId)
                self.productDetail = productDetail
                
                await MainActor.run {
                    self.view?.display(product: productDetail)
                }
            } catch {
                await MainActor.run {
                    self.view?.displayError(message: "Failed to load product details: \(error.localizedDescription)")
                }
            }
        }
    }

    func logLCP() {
        DispatchQueue.main.async {
            self.mviScreenAnalytics.logLCP(screen: "ProductDetail")
        }
    }

    func toggleFavorite() {
        guard let currentProduct = productDetail else { return }

        let updatedProduct = service.toggleFavorite(for: currentProduct)
        productDetail = updatedProduct
        view?.display(product: updatedProduct)
    }
}


