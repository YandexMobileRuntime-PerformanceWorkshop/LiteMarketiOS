import UIKit

// MARK: - Base Skeleton View with Shimmer Animation
final class SkeletonView: UIView {
    private var shimmerLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShimmerLayer()
    }
    
    private func setupShimmerLayer() {
        shimmerLayer?.removeFromSuperlayer()
        
        let shimmer = CAGradientLayer()
        shimmer.colors = [
            UIColor(white: 0.95, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.95, alpha: 1.0).cgColor
        ]
        shimmer.locations = [0, 0.5, 1]
        shimmer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmer.frame = bounds
        
        // Применяем закругления к shimmer слою в соответствии с родительским view
        shimmer.cornerRadius = layer.cornerRadius
        shimmer.masksToBounds = true
        
        layer.addSublayer(shimmer)
        shimmerLayer = shimmer
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        
        shimmer.add(animation, forKey: "shimmer")
    }
    
    func startShimmer() {
        isHidden = false
        setupShimmerLayer()
    }
    
    func stopShimmer() {
        isHidden = true
        shimmerLayer?.removeAllAnimations()
    }
}

// MARK: - Product Skeleton Cell
final class ProductSkeletonCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductSkeletonCell"
    
    // MARK: - Skeleton Components
    private let imageSkeletonView = SkeletonView()
    private let favoriteSkeletonView = SkeletonView()
    private let titleLine1SkeletonView = SkeletonView()
    private let titleLine2SkeletonView = SkeletonView()
    private let priceSkeletonView = SkeletonView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSkeletonViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true
        
        let allSkeletonViews = [
            imageSkeletonView, favoriteSkeletonView, titleLine1SkeletonView,
            titleLine2SkeletonView, priceSkeletonView
        ]
        
        allSkeletonViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
        }
        
        configureSkeletonCornerRadius()
    }
    
    private func configureSkeletonCornerRadius() {
        imageSkeletonView.layer.cornerRadius = 12
        
        favoriteSkeletonView.layer.cornerRadius = 12 // 24/2 = 12 для круга
        
        titleLine1SkeletonView.layer.cornerRadius = 8
        titleLine2SkeletonView.layer.cornerRadius = 8
        
        priceSkeletonView.layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageSkeletonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageSkeletonView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/3),
            
            favoriteSkeletonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteSkeletonView.widthAnchor.constraint(equalToConstant: 24),
            favoriteSkeletonView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLine1SkeletonView.topAnchor.constraint(equalTo: imageSkeletonView.bottomAnchor, constant: 8),
            titleLine1SkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLine1SkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLine1SkeletonView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLine2SkeletonView.topAnchor.constraint(equalTo: titleLine1SkeletonView.bottomAnchor, constant: 4),
            titleLine2SkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLine2SkeletonView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            titleLine2SkeletonView.heightAnchor.constraint(equalToConstant: 18),
            
            priceSkeletonView.topAnchor.constraint(equalTo: titleLine2SkeletonView.bottomAnchor, constant: 6),
            priceSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceSkeletonView.widthAnchor.constraint(equalToConstant: 80),
            priceSkeletonView.heightAnchor.constraint(equalToConstant: 22),
            priceSkeletonView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Animation Control
    func startSkeletonAnimation() {
        let allSkeletonViews = [
            imageSkeletonView, favoriteSkeletonView, titleLine1SkeletonView,
            titleLine2SkeletonView, priceSkeletonView
        ]
        
        allSkeletonViews.enumerated().forEach { index, view in
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                view.startShimmer()
            }
        }
    }
    
    func stopSkeletonAnimation() {
        let allSkeletonViews = [
            imageSkeletonView, favoriteSkeletonView, titleLine1SkeletonView,
            titleLine2SkeletonView, priceSkeletonView
        ]
        
        allSkeletonViews.forEach { $0.stopShimmer() }
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        stopSkeletonAnimation()
    }
}
