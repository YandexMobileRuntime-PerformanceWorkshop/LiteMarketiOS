import UIKit

class ProductNavigationHeaderView: UIView {
    private let backButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    private let reportButton = UIButton(type: .system)

    var onBackTapped: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        shareButton.setImage(UIImage(systemName: "link.circle"), for: .normal)
        shareButton.tintColor = .black

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .black
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        reportButton.setImage(UIImage(systemName: "flag"), for: .normal)
        reportButton.tintColor = .black

        [backButton, shareButton, favoriteButton, reportButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            reportButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            reportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            reportButton.widthAnchor.constraint(equalToConstant: 44),
            reportButton.heightAnchor.constraint(equalToConstant: 44),

            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),

            shareButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            shareButton.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func updateFavoriteState(isFavorite: Bool) {
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.tintColor = isFavorite ? .red : .black
    }

    @objc private func backButtonTapped() {
        onBackTapped?()
    }

    @objc private func favoriteButtonTapped() {
        onFavoriteTapped?()
    }
}

class PaddedLabel: UILabel {
    var edgeInsets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + edgeInsets.left + edgeInsets.right,
            height: size.height + edgeInsets.top + edgeInsets.bottom
        )
    }
}
