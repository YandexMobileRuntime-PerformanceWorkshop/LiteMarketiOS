import UIKit

StartupTimeLogger.markMainEntered()

let applicationDelegateClass: String

applicationDelegateClass = NSStringFromClass(AppDelegate.self)

NetworkPrewarm.run()

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    applicationDelegateClass
)
