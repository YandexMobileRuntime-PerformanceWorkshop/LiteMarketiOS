import DI
import Foundation

final class ProductDetailsAssembly: Assembly {
    
    private lazy var lightWeightAssembly = AssemblyActivator.shared.resolve() as LightWeightAssembly

    override init() {
        super.init()
        
        // MARK: - Data Layer Registration
        register(lifetime: .prototype) { [weak self] () -> ProductDetailRepositoryProtocol in
            guard let self = self else { 
                preconditionFailure("Assembly released") 
            }
            return ProductDetailRepository(
                apiClient: self.lightWeightAssembly.resolve()
            )
        }
        
        // MARK: - Business Layer Registration
        register(lifetime: .prototype) { [weak self] () -> ProductDetailServiceProtocol in
            guard let self = self else { preconditionFailure("Assembly released") }
            return ProductDetailService(
                repository: self.resolve()
            )
        }
        
    }
    
    func createProductDetailsModule(
        for productId: String,
        mviScreenAnalytics: MVIScreenAnalytics
    ) -> ProductDetailViewController {
        let service: ProductDetailServiceProtocol = resolve()
        let presenter = ProductDetailPresenter(
            service: service,
            productId: productId,
            mviScreenAnalytics: mviScreenAnalytics
        )
        let viewController = ProductDetailViewController(
            presenter: presenter
        )
        presenter.view = viewController
        return viewController
    }
}
