import Foundation
import os
public enum StartupTimeLogger {

    enum TimestampType {
        case mainEntry
        case appDidFinishLaunchingEntry
    }

    // MARK: Private

    fileprivate static var values: [TimestampType: PerformanceTimestamp] = [:]

    private static func mark(_ type: TimestampType, value: PerformanceTimestamp) {
        assert(values[type] == nil)
        values[type] = value
    }

    // MARK: Public

    static func markMainEntered() {
        let mainEntryTime = PerformanceTimestamp.now()
        mark(.mainEntry, value: mainEntryTime)
    }
}

extension StartupTimeLogger {
    static func recordStartupTime() {
        let processStartTime = PerformanceTimestamp.processStartTime()
        guard let mainEntryTime = StartupTimeLogger.values[.mainEntry]
        else {
            assertionFailure("mainEntryTime and appDidFinishLaunchingEntryTime did not set")
            return
        }

        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "workshop", category: "Performance")
        let startupTimeMs = Int(round(mainEntryTime.toSince1970().milliseconds - processStartTime.toSince1970().milliseconds))
        logger.info("\("StartupTime", privacy: .public) = \(startupTimeMs) ms")
    }
}
