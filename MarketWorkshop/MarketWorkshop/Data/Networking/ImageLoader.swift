import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil, context: String = "unknown") {
        let startTime = PerformanceTimestamp.now()
        let placeholderImage = placeholder ?? UIImage(systemName: "photo")
        self.tintColor = UIColor.systemGray6

        self.sd_setImage(
            with: url,
            placeholderImage: placeholderImage,
            options: [.retryFailed, .scaleDownLargeImages, .avoidAutoSetImage],
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
                
                // Set image and configure appearance in one atomic operation
                if let image = image, error == nil {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.backgroundColor = .clear
                        self?.tintColor = nil
                        self?.contentMode = .scaleAspectFill
                    }
                }
            }
        )
    }
    
    /// Cancel any ongoing image loading operation
    func cancelImageLoad() {
        sd_cancelCurrentImageLoad()
    }
}
