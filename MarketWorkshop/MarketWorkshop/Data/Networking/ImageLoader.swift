import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil, context: String = "unknown") {
        let startTime = PerformanceTimestamp.now()
        
        let placeholderImage = placeholder ?? UIImage(systemName: "photo")
        
        if placeholder == nil {
            self.backgroundColor = UIColor.systemGray6
            self.tintColor = .gray
            self.contentMode = .center
        }
        
        self.sd_setImage(
            with: url,
            placeholderImage: placeholderImage,
            options: [.progressiveLoad, .retryFailed, .scaleDownLargeImages],
            completed: { [weak self] image, error, cacheType, imageURL in
                let endTime = PerformanceTimestamp.now()
                let loadTime = endTime.elapsed(since: startTime)
                
                PerformanceMetricManager.shared.recordMetric(
                    name: "image_load_time",
                    value: loadTime,
                    context: [
                        "url": url.absoluteString,
                        "context": context,
                        "status": error == nil ? "success" : "failed",
                        "cache_type": cacheType.rawValue
                    ]
                )
                
                if error == nil && image != nil {
                    self?.backgroundColor = .clear
                    self?.tintColor = nil
                    self?.contentMode = .scaleAspectFill
                }
            }
        )
    }
    
    /// Cancel any ongoing image loading operation
    func cancelImageLoad() {
        sd_cancelCurrentImageLoad()
    }
}
