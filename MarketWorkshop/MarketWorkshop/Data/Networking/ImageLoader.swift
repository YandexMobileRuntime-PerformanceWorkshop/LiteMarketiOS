import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil, context: String = "unknown") {
        let startTime = PerformanceTimestamp.now()
        
        if let placeholder = placeholder {
            self.image = placeholder
        } else {
            self.backgroundColor = UIColor.systemGray6
            self.image = UIImage(systemName: "photo")
            self.tintColor = .gray
            self.contentMode = .center
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else { 
                let endTime = PerformanceTimestamp.now()
                let loadTime = endTime.elapsed(since: startTime)
                PerformanceMetricManager.shared.recordMetric(
                    name: "image_load_time",
                    value: loadTime,
                    context: ["url": url.absoluteString, "context": context, "status": "failed"]
                )
                return 
            }

            DispatchQueue.main.async {
                guard let strongSelf = self else { return }

                let endTime = PerformanceTimestamp.now()
                let loadTime = endTime.elapsed(since: startTime)

                strongSelf.image = image
                strongSelf.backgroundColor = .clear
                strongSelf.tintColor = nil
                strongSelf.contentMode = .scaleAspectFill
                
                PerformanceMetricManager.shared.recordMetric(
                    name: "image_load_time",
                    value: loadTime,
                    context: ["url": url.absoluteString, "context": context, "status": "success"]
                )
            }
        }.resume()
    }
}
