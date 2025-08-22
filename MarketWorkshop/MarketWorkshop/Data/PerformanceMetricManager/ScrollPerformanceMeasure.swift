import QuartzCore
import os

public struct PerformanceData {
    public let name: String
    public let hitchRatio: Int
}

final class ScrollPerformanceMeasure {

    // MARK: Private

    private var isScrollActive = false
    private var displayLink: CADisplayLink?
    private var startTime: TimeInterval = .zero
    private var nextFrameTargetTimestamp: TimeInterval?

    // MARK: Private PerformanceData

    private var name: String = ""
    private var hitchTime: TimeInterval = .zero

    // MARK: - Lifecycle

    deinit {
        self.displayLink?.invalidate()
    }

    // MARK: Private Methods

    private func makeDisplayLink() -> CADisplayLink {
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(displayLinkAction)
        )
        displayLink.add(to: .main, forMode: .common)
        return displayLink
    }

    @objc private func displayLinkAction(displayLink: CADisplayLink) {
        hitchTime += calculateHitchTime(for: displayLink.timestamp)
        nextFrameTargetTimestamp = displayLink.targetTimestamp
    }

    private func calculateHitchTime(for timestamp: TimeInterval) -> TimeInterval {
        guard let targetTimestamp = nextFrameTargetTimestamp else {
            return 0
        }
        return max(timestamp - targetTimestamp, 0)
    }

    func start(measureName: String) {
        if isScrollActive { return }

        self.name = measureName
        displayLink = makeDisplayLink()
        isScrollActive = true
        startTime = CFAbsoluteTimeGetCurrent()
    }

    @discardableResult
    func stop() -> PerformanceData? {
        displayLink?.invalidate()
        let duration = CFAbsoluteTimeGetCurrent() - startTime

        guard isScrollActive, duration > sufficientDuration else {
            isScrollActive = false
            return nil
        }

        isScrollActive = false
        return PerformanceData(
            name: name,
            hitchRatio: Int((hitchTime / duration) * 100)
        )
    }
}

private let sufficientDuration: TimeInterval = 1.0
