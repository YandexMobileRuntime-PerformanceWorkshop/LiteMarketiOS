import UIKit

class SellerView: UIView {
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let ratingLabel = UILabel()
    private let reviewsLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)

    var onFavoriteTapped: (() -> Void)?

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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        containerView.layer.cornerRadius = 16
        addSubview(containerView)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.layer.cornerRadius = 18
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .white

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .black

        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 4
        ratingStackView.alignment = .center

        let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
        starImageView.tintColor = UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.0) // Gold color
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .darkGray

        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewsLabel.font = UIFont.systemFont(ofSize: 14)
        reviewsLabel.textColor = .darkGray

        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewsLabel)

        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .gray
        chevronImageView.contentMode = .scaleAspectFit

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .gray
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        containerView.addSubview(logoImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(ratingStackView)
        containerView.addSubview(chevronImageView)
        containerView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            logoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 36),
            logoImageView.heightAnchor.constraint(equalToConstant: 36),

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor, constant: -12),

            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),

            favoriteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }

    // MARK: - Configuration
    func configure(with seller: ProductDetail.Seller) {
        nameLabel.text = seller.name

        if let image = UIImage(named: seller.logo) {
            logoImageView.image = image
        } else {
            logoImageView.image = UIImage(systemName: "storefront")
            logoImageView.tintColor = .darkGray
        }

        ratingLabel.text = String(format: "%.1f", seller.rating)

        reviewsLabel.text = "• \(seller.reviewsCount) оценок"

        updateFavoriteButtonState(isFavorite: seller.isFavorite)
    }

    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        onFavoriteTapped?()
    }

    // MARK: - Helper Methods
    func updateFavoriteButtonState(isFavorite: Bool) {
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.tintColor = isFavorite ? .red : .gray
    }
}
