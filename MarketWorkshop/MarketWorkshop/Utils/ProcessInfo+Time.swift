import Foundation
import os

extension ProcessInfo {
    static let appWasPrewarmed = processInfo.environment["ActivePrewarm"] == "1"

    static var processStartDate: Date {
        let startTime = processStartTime
        let timeInterval = TimeInterval(startTime.tv_sec) + TimeInterval(startTime.tv_usec) / 1e6
        return Date(timeIntervalSince1970: timeInterval)
    }

    static var processStartTime: timeval {
        var kinfo = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0)
        return kinfo.kp_proc.p_starttime
    }

    static var processCurrentTime: timeval {
        var time = timeval(tv_sec: 0, tv_usec: 0)
        gettimeofday(&time, nil)
        return time
    }
}

extension TimeInterval {
    var milliseconds: TimeInterval {
        self * 1_000
    }
}
