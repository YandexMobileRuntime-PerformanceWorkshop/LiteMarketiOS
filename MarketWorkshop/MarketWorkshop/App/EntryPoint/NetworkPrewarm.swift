import Foundation
enum NetworkPrewarm {
    static func run() {

        AssemblyActivator.shared.activateLightWeightAssembly()

        let lightWeightAssembly = AssemblyActivator.shared.resolve() as LightWeightAssembly
        let networkRequestPrewarmManager = lightWeightAssembly.resolve() as NetworkRequestPrewarmManager

        networkRequestPrewarmManager.prewarmRoutes([PrewarmRoute.prewarmBaseAPI()])
    }
}
