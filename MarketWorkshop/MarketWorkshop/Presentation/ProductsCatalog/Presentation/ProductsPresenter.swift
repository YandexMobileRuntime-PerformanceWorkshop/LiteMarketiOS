import Foundation

// MARK: - Products View Protocol
protocol ProductsView: AnyObject {
    func show(products: [Product], hasMorePages: Bool)
    func showError(_ error: Error)
    func showLoading(_ isLoading: Bool)
    func showPaginationLoading(_ isLoading: Bool)
}

// MARK: - Products Presenter Protocol
protocol ProductsPresenterProtocol: AnyObject {
    var view: ProductsView? { get set }
    
    func viewDidLoad()
    func loadProducts(refresh: Bool)
    func loadNextPageIfNeeded()
    func sendAnalytics(for product: Product, at indexPath: IndexPath)
}

// MARK: - Products Presenter Implementation
final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsView?
    private let service: ProductsServiceProtocol
    private var hasMorePages = true
    
    init(service: ProductsServiceProtocol) {
        self.service = service
    }

    // MARK: - ProductsPresenterProtocol Methods
    func viewDidLoad() {
        loadProducts(refresh: true)
    }
    
    func loadProducts(refresh: Bool = false) {
        guard !service.isCurrentlyLoading() else { return }
        
        if refresh {
            hasMorePages = true
            view?.showLoading(true)
        } else {
            view?.showPaginationLoading(true)
        }

        Task(priority: .userInitiated) {
            do {
                let result = try await service.loadProducts(refresh: refresh)
                
                await MainActor.run {
                    if result.isRefresh {
                        self.view?.showLoading(false)
                    } else {
                        self.view?.showPaginationLoading(false)
                    }
                    
                    self.hasMorePages = result.hasMorePages
                    
                    self.view?.show(products: result.products, hasMorePages: result.hasMorePages)
                }
            } catch {
                await MainActor.run {
                    if refresh {
                        self.view?.showLoading(false)
                    } else {
                        self.view?.showPaginationLoading(false)
                    }
                    
                    self.view?.showError(error)
                }
            }
        }
    }
    
    func loadNextPageIfNeeded() {
        guard hasMorePages else { return }
        
        loadProducts(refresh: false)
    }

    public func sendAnalytics(for product: Product, at indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
            var payload: [String: Any] = [
                "event": "product_open",
                "product_id": product.id,
                "timestamp": Date().timeIntervalSince1970,
                "position": ["row": indexPath.item / 2, "column": indexPath.item % 2],
                "title_length": product.title.count
            ]
            var interactions: [[String: Any]] = []
            for i in 0..<150 {
                interactions.append([
                    "offset": i * 5,
                    "velocity": Double.random(in: 0...3),
                    "direction": i % 2 == 0 ? "down" : "up"
                ])
            }
            payload["interactions"] = interactions

            AnalyticsManager.send(event: "product_open", payload: payload)
        }
    }
}
