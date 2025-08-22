import Foundation

enum PrewarmRoute {
    static func prewarmBaseAPI() -> APIRoute<PrewarmResponse> {
        var route = APIRoute<PrewarmResponse>(decoder: PrewarmResponseDecoder())
        route.routeURL = "ping"
        route.method = .head
        route.needAuthorization = false
        return route
    }
}
