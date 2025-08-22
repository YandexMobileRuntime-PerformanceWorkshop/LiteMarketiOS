import UIKit
import SDWebImage

class ProductGalleryView: UIView, UIScrollViewDelegate {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let imageContainerView = UIView()
    private let similarProductsButton = UIButton()

    // MARK: - Properties
    private var currentPage = 0
    private var imageViews: [UIImageView] = []

    var onSimilarProductsTapped: (() -> Void)?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .white

        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageContainerView)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)

        similarProductsButton.translatesAutoresizingMaskIntoConstraints = false
        similarProductsButton.setTitle("Похожие", for: .normal)
        similarProductsButton.setTitleColor(.black, for: .normal)
        similarProductsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        similarProductsButton.backgroundColor = .white
        similarProductsButton.layer.cornerRadius = 16
        similarProductsButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        similarProductsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        similarProductsButton.layer.shadowRadius = 4
        similarProductsButton.layer.shadowOpacity = 1
        similarProductsButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        similarProductsButton.tintColor = .black
        similarProductsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        similarProductsButton.addTarget(self, action: #selector(similarProductsButtonTapped), for: .touchUpInside)

        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(similarProductsButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 350),

            imageContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            similarProductsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            similarProductsButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            similarProductsButton.heightAnchor.constraint(equalToConstant: 40),
            similarProductsButton.widthAnchor.constraint(equalToConstant: 120),

            bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8)
        ])
    }

    // MARK: - Configuration
    func configure(with product: ProductDetail) {
        imageViews.forEach { 
            $0.cancelImageLoad()
            $0.removeFromSuperview() 
        }
        imageViews.removeAll()

        let images = product.images.isEmpty ? [""] : product.images
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0

        var lastImageView: UIImageView?

        for (index, imageURL) in images.enumerated() {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor.systemGray6

            if let url = URL(string: imageURL) {
                imageView.loadImage(from: url, context: "product_gallery")
            } else {
                imageView.image = UIImage(systemName: "photo")
                imageView.tintColor = .gray
                imageView.contentMode = .center
            }

            imageContainerView.addSubview(imageView)
            imageViews.append(imageView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])

            if let lastImageView = lastImageView {
                imageView.leadingAnchor.constraint(equalTo: lastImageView.trailingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor).isActive = true
            }

            if index == images.count - 1 {
                imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor).isActive = true
            }

            lastImageView = imageView
        }

        let widthConstraint = imageContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(images.count))
        widthConstraint.priority = .required
        widthConstraint.isActive = true

        layoutIfNeeded()

        scrollView.contentSize = CGSize(
            width: scrollView.frame.width * CGFloat(images.count),
            height: scrollView.frame.height
        )
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth

        let page = Int(round(fractionalPage))
        if pageControl.currentPage != page && page >= 0 && page < pageControl.numberOfPages {
            pageControl.currentPage = page
            currentPage = page
        }
    }

    // MARK: - Actions
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let offsetX = CGFloat(page) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    @objc private func similarProductsButtonTapped() {
        onSimilarProductsTapped?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !imageViews.isEmpty {
            scrollView.contentSize = CGSize(
                width: scrollView.frame.width * CGFloat(imageViews.count),
                height: scrollView.frame.height
            )
        }
    }
}
