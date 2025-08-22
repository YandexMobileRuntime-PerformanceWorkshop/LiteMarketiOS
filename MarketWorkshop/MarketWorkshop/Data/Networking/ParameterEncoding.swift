import Foundation

// MARK: - Parameter Encoding
protocol ParameterEncoding {
    func encode(_ parameters: [String: Any], into request: inout URLRequest) throws
}

// MARK: - URL Encoding
struct URLEncoding: ParameterEncoding {
    func encode(_ parameters: [String: Any], into request: inout URLRequest) throws {
        guard let url = request.url else { throw APIError.invalidURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            urlComponents.queryItems = queryItems
            request.url = urlComponents.url
        }
    }
}

// MARK: - JSON Encoding
struct JSONEncoding: ParameterEncoding {
    func encode(_ parameters: [String: Any], into request: inout URLRequest) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw APIError.encodingError(error)
        }
    }
} 
