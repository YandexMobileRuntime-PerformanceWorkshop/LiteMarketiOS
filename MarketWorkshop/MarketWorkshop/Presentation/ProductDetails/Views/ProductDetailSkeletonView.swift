import UIKit

final class DetailsSkeletonView: UIView {
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

final class ProductDetailSkeletonView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let gallerySkeletonView = DetailsSkeletonView()
    private let titleSkeletonView = DetailsSkeletonView()
    private let subtitleSkeletonView = DetailsSkeletonView()
    private let priceSkeletonView = DetailsSkeletonView()
    private let oldPriceSkeletonView = DetailsSkeletonView()
    private let promoSkeletonView = DetailsSkeletonView()
    private let sellerSkeletonView = DetailsSkeletonView()
    private let sellerRatingSkeletonView = DetailsSkeletonView()
    private let deliveryTitleSkeletonView = DetailsSkeletonView()
    private let deliveryOption1SkeletonView = DetailsSkeletonView()
    private let deliveryOption2SkeletonView = DetailsSkeletonView()
    private let actionButtonsSkeletonView = DetailsSkeletonView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupSkeletonLayout() {
        backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let allSkeletonViews = [
            gallerySkeletonView, titleSkeletonView, subtitleSkeletonView,
            priceSkeletonView, oldPriceSkeletonView, promoSkeletonView,
            sellerSkeletonView, sellerRatingSkeletonView, deliveryTitleSkeletonView,
            deliveryOption1SkeletonView, deliveryOption2SkeletonView, actionButtonsSkeletonView
        ]
        
        allSkeletonViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            $0.layer.masksToBounds = true
            contentView.addSubview($0)
        }
        
        // Настройка разных радиусов закругления для разных типов блоков
        configureSkeletonCornerRadius()
        
        setupConstraints()
    }
    
    private func configureSkeletonCornerRadius() {
        gallerySkeletonView.layer.cornerRadius = 16
        titleSkeletonView.layer.cornerRadius = 12
        subtitleSkeletonView.layer.cornerRadius = 10
        priceSkeletonView.layer.cornerRadius = 14
        oldPriceSkeletonView.layer.cornerRadius = 12
        promoSkeletonView.layer.cornerRadius = 16
        actionButtonsSkeletonView.layer.cornerRadius = 20
        sellerSkeletonView.layer.cornerRadius = 10
        sellerRatingSkeletonView.layer.cornerRadius = 12
        deliveryTitleSkeletonView.layer.cornerRadius = 10
        deliveryOption1SkeletonView.layer.cornerRadius = 14
        deliveryOption2SkeletonView.layer.cornerRadius = 14
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -72),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            gallerySkeletonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            gallerySkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gallerySkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gallerySkeletonView.heightAnchor.constraint(equalToConstant: 300),
            
            titleSkeletonView.topAnchor.constraint(equalTo: gallerySkeletonView.bottomAnchor, constant: 16),
            titleSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleSkeletonView.heightAnchor.constraint(equalToConstant: 24),
            
            subtitleSkeletonView.topAnchor.constraint(equalTo: titleSkeletonView.bottomAnchor, constant: 8),
            subtitleSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleSkeletonView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            subtitleSkeletonView.heightAnchor.constraint(equalToConstant: 18),
            
            priceSkeletonView.topAnchor.constraint(equalTo: subtitleSkeletonView.bottomAnchor, constant: 16),
            priceSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceSkeletonView.widthAnchor.constraint(equalToConstant: 120),
            priceSkeletonView.heightAnchor.constraint(equalToConstant: 28),
            
            oldPriceSkeletonView.topAnchor.constraint(equalTo: priceSkeletonView.topAnchor),
            oldPriceSkeletonView.leadingAnchor.constraint(equalTo: priceSkeletonView.trailingAnchor, constant: 12),
            oldPriceSkeletonView.widthAnchor.constraint(equalToConstant: 80),
            oldPriceSkeletonView.heightAnchor.constraint(equalToConstant: 20),
            
            promoSkeletonView.topAnchor.constraint(equalTo: priceSkeletonView.bottomAnchor, constant: 12),
            promoSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            promoSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            promoSkeletonView.heightAnchor.constraint(equalToConstant: 44),
            
            sellerSkeletonView.topAnchor.constraint(equalTo: promoSkeletonView.bottomAnchor, constant: 12),
            sellerSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sellerSkeletonView.widthAnchor.constraint(equalToConstant: 150),
            sellerSkeletonView.heightAnchor.constraint(equalToConstant: 20),
            
            sellerRatingSkeletonView.topAnchor.constraint(equalTo: sellerSkeletonView.topAnchor),
            sellerRatingSkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sellerRatingSkeletonView.widthAnchor.constraint(equalToConstant: 100),
            sellerRatingSkeletonView.heightAnchor.constraint(equalToConstant: 20),
            
            deliveryTitleSkeletonView.topAnchor.constraint(equalTo: sellerSkeletonView.bottomAnchor, constant: 12),
            deliveryTitleSkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deliveryTitleSkeletonView.widthAnchor.constraint(equalToConstant: 120),
            deliveryTitleSkeletonView.heightAnchor.constraint(equalToConstant: 20),
            
            deliveryOption1SkeletonView.topAnchor.constraint(equalTo: deliveryTitleSkeletonView.bottomAnchor, constant: 8),
            deliveryOption1SkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deliveryOption1SkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deliveryOption1SkeletonView.heightAnchor.constraint(equalToConstant: 36),
            
            deliveryOption2SkeletonView.topAnchor.constraint(equalTo: deliveryOption1SkeletonView.bottomAnchor, constant: 8),
            deliveryOption2SkeletonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deliveryOption2SkeletonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deliveryOption2SkeletonView.heightAnchor.constraint(equalToConstant: 36),
            deliveryOption2SkeletonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            actionButtonsSkeletonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButtonsSkeletonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButtonsSkeletonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            actionButtonsSkeletonView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Animation Control
    func startSkeletonAnimation() {
        let allSkeletonViews = [
            gallerySkeletonView, titleSkeletonView, subtitleSkeletonView,
            priceSkeletonView, oldPriceSkeletonView, promoSkeletonView,
            sellerSkeletonView, sellerRatingSkeletonView, deliveryTitleSkeletonView,
            deliveryOption1SkeletonView, deliveryOption2SkeletonView, actionButtonsSkeletonView
        ]
        
        isHidden = false
        allSkeletonViews.forEach { $0.startShimmer() }
    }
    
    func stopSkeletonAnimation() {
        let allSkeletonViews = [
            gallerySkeletonView, titleSkeletonView, subtitleSkeletonView,
            priceSkeletonView, oldPriceSkeletonView, promoSkeletonView,
            sellerSkeletonView, sellerRatingSkeletonView, deliveryTitleSkeletonView,
            deliveryOption1SkeletonView, deliveryOption2SkeletonView, actionButtonsSkeletonView
        ]
        
        allSkeletonViews.forEach { $0.stopShimmer() }
        isHidden = true
    }
}
