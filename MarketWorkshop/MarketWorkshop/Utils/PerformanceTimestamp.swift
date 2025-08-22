import Foundation

struct PerformanceTimestamp {
    private let timeInterval: TimeInterval

    static func now() -> PerformanceTimestamp {
        let currentTime = ProcessInfo.processCurrentTime
        return .init(timeInterval: Double(currentTime.tv_sec) + Double(currentTime.tv_usec) / 1e6)
    }

    static func processStartTime() -> PerformanceTimestamp {
        let startTime = ProcessInfo.processStartTime
        return .init(timeInterval: Double(startTime.tv_sec) + Double(startTime.tv_usec) / 1e6)
    }

    func elapsed(since timestamp: PerformanceTimestamp) -> TimeInterval {
        timeInterval - timestamp.timeInterval
    }

    func toSince1970() -> TimeInterval {
        let elapsedDelta = PerformanceTimestamp.now().elapsed(since: self)
        return Date().timeIntervalSince1970 - elapsedDelta
    }
}
