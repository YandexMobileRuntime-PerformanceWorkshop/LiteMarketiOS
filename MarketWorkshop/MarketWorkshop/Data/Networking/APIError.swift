import Foundation

// MARK: - APIError
enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case httpError(statusCode: Int, data: Data?)
    case encodingError(Error)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode, _):
            return "HTTP error with status code: \(statusCode)"
        case .encodingError(let error):
            return "Encoding error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
} 
