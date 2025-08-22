import DI
import Foundation

final class AssemblyActivator: Assembly {
    @objc static let shared = AssemblyActivator()

    @objc func activateLightWeightAssembly() {
        register(lifetime: .singleton(lazy: true), initCall: LightWeightAssembly.init)
    }

    func activate() {
        register(lifetime: .singleton(lazy: true), initCall: ProductCatalogAssembly.init)
        register(lifetime: .singleton(lazy: true), initCall: ProductDetailsAssembly.init)
    }
}
