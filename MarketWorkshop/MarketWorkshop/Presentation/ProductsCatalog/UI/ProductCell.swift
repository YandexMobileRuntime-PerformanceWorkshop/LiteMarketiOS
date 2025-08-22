import UIKit
import SDWebImage

final class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let favoriteButton = UIButton()

    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any ongoing image loading
        imageView.cancelImageLoad()
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)

        priceLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        priceLabel.textColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

        let heartImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.tintColor = .lightGray
        favoriteButton.isUserInteractionEnabled = false // not tappable in this example

        [imageView, titleLabel, priceLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/3),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = product.price

        if let imageUrl = product.url, let url = URL(string: imageUrl) {
            imageView.loadImage(from: url, context: "product_catalog")
        } else {
            imageView.backgroundColor = UIColor.systemGray6
            imageView.image = UIImage(systemName: "photo")
            imageView.tintColor = .gray
            imageView.contentMode = .center
        }
    }
}
