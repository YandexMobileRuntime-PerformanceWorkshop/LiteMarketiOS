import Foundation

// MARK: - Products View Protocol
protocol ProductsView: AnyObject {
    func show(products: [Product])
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
}

// MARK: - Products Presenter Implementation
final class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsView?
    private let service: ProductsServiceProtocol
    
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
                    
                    self.view?.show(products: result.products)
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
        loadProducts(refresh: false)
    }
}
