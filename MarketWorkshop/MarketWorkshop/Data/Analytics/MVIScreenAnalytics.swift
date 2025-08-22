import Foundation
import os

enum LCPTrackingTime {
    case fromAppStart
    case fromScreenCreation(timestamp: PerformanceTimestamp)

    var time: PerformanceTimestamp {
        switch self {
        case .fromAppStart:
            return PerformanceTimestamp.processStartTime()
        case .fromScreenCreation(let timestamp):
            return timestamp
        }
    }

}

class MVIScreenAnalytics {

    private var creationTime: PerformanceTimestamp
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "workshop", category: "Performance")

    init(creationTime: LCPTrackingTime) {
        self.creationTime = creationTime.time
    }

    func logLCP(screen: String) {
        let finishTime = PerformanceTimestamp.now()
        let lcp = Int(round(finishTime.toSince1970().milliseconds - creationTime.toSince1970().milliseconds))
        logger.info("\(screen, privacy: .public): LCP = \(lcp) ms")
    }


}
