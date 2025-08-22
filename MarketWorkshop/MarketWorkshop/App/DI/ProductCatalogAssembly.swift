import DI
import Foundation

final class ProductCatalogAssembly: Assembly {
    
    private lazy var lightWeightAssembly = AssemblyActivator.shared.resolve() as LightWeightAssembly

    override init() {
        super.init()
        
        // MARK: - Data Layer Registration
        register(lifetime: .prototype) { [weak self] () -> ProductsRepositoryProtocol in
            guard let self = self else { 
                preconditionFailure("Assembly released") 
            }
            return ProductsRepository(
                apiClient: lightWeightAssembly.resolve()
            )
        }
        
        // MARK: - Business Layer Registration
        register(lifetime: .prototype) { [weak self] () -> ProductsServiceProtocol in
            guard let self = self else { preconditionFailure("Assembly released") }
            return ProductsService(
                repository: self.resolve()
            )
        }
        
        // MARK: - Presentation Layer Registration
        register(lifetime: .prototype) { [weak self] () -> ProductsPresenterProtocol in
            guard let self = self else { preconditionFailure("Assembly released") }
            return ProductsPresenter(
                service: self.resolve()
            )
        }
        
        register(lifetime: .prototype) { [weak self] () -> ProductsViewController in
            guard let self = self else { preconditionFailure("Assembly released") }
            return ProductsViewController(
                presenter: self.resolve()
            )
        }
    }
}
