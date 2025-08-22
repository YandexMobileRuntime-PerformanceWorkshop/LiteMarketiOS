import DI
import Foundation

class LightWeightAssembly: Assembly {

    override init() {
        super.init()

        register(lifetime: .singleton(lazy: true)) { [weak self] () -> AppURLSessionDelegate in
            guard let _ = self else { preconditionFailure("Assembly released") }
            return AppURLSessionDelegate()
        }

        register(lifetime: .singleton(lazy: true)) { [weak self] () -> URLSession in
            guard let self = self else { preconditionFailure("Assembly released") }

            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 60
            configuration.waitsForConnectivity = true

            return URLSession(
                configuration: configuration,
                delegate: self.resolve() as AppURLSessionDelegate,
                delegateQueue: nil
            )
        }

        register(lifetime: .singleton(lazy: true)) { [weak self] () -> APIClient in
            guard let self = self else { preconditionFailure("Assembly released") }
            return APIClient(
                urlSession: self.resolve()
            )
        }
        register(lifetime: .prototype) { [weak self] () -> NetworkRequestPrewarmManager in
            guard let self = self else { preconditionFailure("Assembly released") }
            return NetworkRequestPrewarmManager(
                apiClient: self.resolve()
            )
        }
    }

}
