import Foundation

// MARK: - API Route
struct APIRoute<T> {
    var routeURL: String = ""
    var needAuthorization: Bool = false
    var method: HTTPMethod = .get
    var parameters: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding()
    var decoder: ResponseDecoder<T>
    var headers: [String: String] = [:]
    
    init(decoder: ResponseDecoder<T>) {
        self.decoder = decoder
    }
    
    init() where T: Codable {
        self.decoder = CodableResponseDecoder<T>()
    }
} 
