import UIKit

class ProductInfoView: UIView {
    private let originalBadge = PaddedLabel()
    private let manufacturerButton = UIButton()
    private let titleLabel = UILabel()
    private let ratingView = UIStackView()
    private let ratingLabel = UILabel()
    private let reviewCountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        originalBadge.translatesAutoresizingMaskIntoConstraints = false
        originalBadge.text = "ОРИГИНАЛ"
        originalBadge.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        originalBadge.textColor = .darkGray
        originalBadge.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        originalBadge.layer.cornerRadius = 12
        originalBadge.clipsToBounds = true
        originalBadge.edgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        manufacturerButton.translatesAutoresizingMaskIntoConstraints = false
        manufacturerButton.setTitle("Pragma", for: .normal)
        manufacturerButton.setTitleColor(.black, for: .normal)
        manufacturerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        manufacturerButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        manufacturerButton.semanticContentAttribute = .forceRightToLeft
        manufacturerButton.tintColor = .black

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black

        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.axis = .horizontal
        ratingView.spacing = 4
        ratingView.alignment = .center

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        ratingLabel.textColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0) // Gold color

        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCountLabel.font = UIFont.systemFont(ofSize: 14)
        reviewCountLabel.textColor = .gray

        for _ in 1...5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0) // Gold color
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 16),
                starImageView.heightAnchor.constraint(equalToConstant: 16)
            ])
            ratingView.addArrangedSubview(starImageView)
        }
        ratingView.addArrangedSubview(ratingLabel)
        ratingView.addArrangedSubview(reviewCountLabel)

        addSubview(originalBadge)
        addSubview(manufacturerButton)
        addSubview(titleLabel)
        addSubview(ratingView)

        NSLayoutConstraint.activate([
            originalBadge.topAnchor.constraint(equalTo: topAnchor),
            originalBadge.leadingAnchor.constraint(equalTo: leadingAnchor),

            manufacturerButton.topAnchor.constraint(equalTo: originalBadge.bottomAnchor, constant: 8),
            manufacturerButton.leadingAnchor.constraint(equalTo: leadingAnchor),

            titleLabel.topAnchor.constraint(equalTo: manufacturerButton.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with product: ProductDetail) {
        originalBadge.isHidden = !product.manufacturer.isOriginal

        manufacturerButton.setTitle(product.manufacturer.name, for: .normal)

        titleLabel.text = product.title

        ratingLabel.text = String(format: "%.1f", product.rating.score)
        reviewCountLabel.text = "(\(product.rating.reviewsCount))"
    }
}
