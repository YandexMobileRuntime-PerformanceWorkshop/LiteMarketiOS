import Foundation

// MARK: - APIClient
final class APIClient {
    private let urlSession: URLSession
    private let baseURL: String = "https://bbapkfh3cnqi1rvo0gla.containers.yandexcloud.net"
    private var authToken: String?
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    private func constructURL(from path: String) -> String {
        if path.isEmpty {
            return baseURL
        }
        
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return "\(baseURL)/\(cleanPath)"
    }
    
    func request<T>(route: APIRoute<T>) async throws -> T {
        let fullURL = constructURL(from: route.routeURL)
        guard let url = URL(string: fullURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        
        try route.encoding.encode(route.parameters, into: &request)
        
        route.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if route.needAuthorization, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
                }
            }
            
            do {
                return try route.decoder.decode(data)
            } catch {
                throw APIError.decodingError(error)
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
} 
