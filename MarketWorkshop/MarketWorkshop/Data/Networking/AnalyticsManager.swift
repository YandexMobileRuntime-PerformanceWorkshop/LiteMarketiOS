import Foundation
import UIKit

class AnalyticsManager {

    private static let baseURL: String = "https://bbapkfh3cnqi1rvo0gla.containers.yandexcloud.net/analytics"

    static func send(event: String, payload: [String: Any]) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else { return }
        request.httpBody = data
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { _, _, _ in
            semaphore.signal()
        }.resume()
        semaphore.wait()
    }
}
