//
//  PrewarmManager.swift
//  MarketWorkshop
//
//  Created by Daniil Shlapak on 07.08.2025.
//

import Foundation

// MARK: - Network Request Prewarm Manager
final class NetworkRequestPrewarmManager {
    
    private let apiClient: APIClient
    private let prewarmQueue = DispatchQueue(label: "prewarm.queue", qos: .utility)
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    public func prewarmRoutes(_ routes: [APIRoute<PrewarmResponse>]) {
        Task {
            await withTaskGroup(of: PrewarmResponse?.self) { group in
                for route in routes {
                    group.addTask { [weak self] in
                        return try? await self?.apiClient.request(route: route)
                    }
                }
            }
        }
    }
}
