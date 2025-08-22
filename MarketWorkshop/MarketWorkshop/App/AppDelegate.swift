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
        // Configure memory cache limit (50 MB)
        SDImageCache.shared.config.maxMemoryCost = 50 * 1024 * 1024
        
        // Configure disk cache limit (200 MB)
        SDImageCache.shared.config.maxDiskSize = 200 * 1024 * 1024
        
        // Cache for 1 week
        SDImageCache.shared.config.maxDiskAge = 60 * 60 * 24 * 7
        
        // Enable memory caching
        SDImageCache.shared.config.shouldCacheImagesInMemory = true
        
        // Configure downloader for optimal performance
        SDWebImageDownloader.shared.config.downloadTimeout = 30
        SDWebImageDownloader.shared.config.maxConcurrentDownloads = 6
                
        // Configure options for better performance
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { url, options, context in
            var newOptions = options
            // Enable scale down for large images to save memory
            newOptions.insert(.scaleDownLargeImages)
            // Enable progressive loading for better UX
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

