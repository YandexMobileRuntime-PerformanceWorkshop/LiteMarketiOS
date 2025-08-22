import UIKit
import SDWebImage

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StartupTimeLogger.recordStartupTime()
        configureSDWebImage()
        return true
    }
    
    // MARK: - SDWebImage Configuration
    private func configureSDWebImage() {
        SDImageCache.shared.config.maxMemoryCost = 50 * 1024 * 1024
        
        SDImageCache.shared.config.maxDiskSize = 200 * 1024 * 1024
        
        SDImageCache.shared.config.maxDiskAge = 60 * 60 * 24 * 7
        
        SDImageCache.shared.config.shouldCacheImagesInMemory = true
        
        SDWebImageDownloader.shared.config.downloadTimeout = 30
        SDWebImageDownloader.shared.config.maxConcurrentDownloads = 6
                
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { url, options, context in
            var newOptions = options
            newOptions.insert(.scaleDownLargeImages)
            newOptions.insert(.progressiveLoad)
            return SDWebImageOptionsResult(options: newOptions, context: context)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

