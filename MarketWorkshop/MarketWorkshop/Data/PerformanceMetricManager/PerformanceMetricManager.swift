import Foundation
import os

public struct PerformanceMetric {
    public let name: String
    public let value: TimeInterval
    public let context: [String: Any]
    public let timestamp: Date
    
    public init(name: String, value: TimeInterval, context: [String: Any] = [:]) {
        self.name = name
        self.value = value
        self.context = context
        self.timestamp = Date()
    }
}

public final class PerformanceMetricManager {
    
    public static let shared = PerformanceMetricManager()

    private var measure: ScrollPerformanceMeasure?
    private var metrics: [PerformanceMetric] = []
    private let metricsQueue = DispatchQueue(label: "performance.metrics", qos: .utility)

    private init() {
    }

    public func stopCurrentMeasure() {
        measure?.stop()
        measure = nil
    }

    public func start(measureName: String) {
        guard
            !measureName.isEmpty,
            measure == nil
        else {
            return
        }

        let newMeasure = ScrollPerformanceMeasure()
        newMeasure.start(measureName: measureName)
        measure = newMeasure
    }

    public func stop(name: String, responseInfo: [String: String]) {
        guard
            !name.isEmpty,
            let measure,
            let result = measure.stop()
        else {
            self.measure = nil
            return
        }
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "workshop", category: "Performance")
        logger.info("\(result.name, privacy: .public): hitchRatio = \(result.hitchRatio)% (>1s scroll)")
        self.measure = nil
    }
    
    // MARK: - Generic Metrics
    
    public func recordMetric(name: String, value: TimeInterval, context: [String: Any] = [:]) {
        let metric = PerformanceMetric(name: name, value: value, context: context)
        
        metricsQueue.async { [weak self] in
            self?.metrics.append(metric)
        }
        
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "workshop", category: "Performance")
        let contextStr = context.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
        let valueMs = Int(round(value * 1000))
        logger.info("\(name, privacy: .public): \(valueMs) ms [\(contextStr, privacy: .public)]")
    }
    
    public func getMetrics(named name: String) -> [PerformanceMetric] {
        return metricsQueue.sync {
            return metrics.filter { $0.name == name }
        }
    }
    
    public func getAllMetrics() -> [PerformanceMetric] {
        return metricsQueue.sync {
            return metrics
        }
    }
    
    public func clearMetrics() {
        metricsQueue.async { [weak self] in
            self?.metrics.removeAll()
        }
    }
}
