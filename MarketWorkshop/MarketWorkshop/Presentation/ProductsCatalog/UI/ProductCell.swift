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
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        imageView.cancelImageLoad()
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
            contentView.addSubview($0)
        }
    }

    private func setupLayout() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // ✅ Manual frame layout for maximum performance
        let bounds = contentView.bounds
        let imageHeight = bounds.width * 4/3
        
        // Favorite button - top right corner
        favoriteButton.frame = CGRect(
            x: bounds.width - 34, 
            y: 10, 
            width: 24, 
            height: 24
        )
        
        // Image view - full width, 4:3 aspect ratio
        imageView.frame = CGRect(
            x: 0, 
            y: 0, 
            width: bounds.width, 
            height: imageHeight
        )
        
        // Title label - below image with margins
        let titleY = imageHeight + 8
        let labelWidth = bounds.width - 20
        let titleHeight: CGFloat = 44 // Enough for 2 lines
        titleLabel.frame = CGRect(
            x: 10, 
            y: titleY, 
            width: labelWidth, 
            height: titleHeight
        )
        
        // Price label - below title
        let priceY = titleY + titleHeight + 6
        let priceHeight: CGFloat = 22 // Single line
        priceLabel.frame = CGRect(
            x: 10, 
            y: priceY, 
            width: labelWidth, 
            height: priceHeight
        )
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
