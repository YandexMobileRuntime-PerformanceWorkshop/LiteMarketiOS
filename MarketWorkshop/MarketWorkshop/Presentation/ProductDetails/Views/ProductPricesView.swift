import UIKit

class ProductPriceView: UIView {
    private let priceContainer = UIView()
    private let currentPriceLabel = UILabel()
    private let paymentMethodIcon = UIImageView()
    private let oldPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let alternativePriceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        priceContainer.translatesAutoresizingMaskIntoConstraints = false
        priceContainer.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        priceContainer.layer.cornerRadius = 16

        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        currentPriceLabel.textColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0) // Green color

        paymentMethodIcon.translatesAutoresizingMaskIntoConstraints = false
        paymentMethodIcon.image = UIImage(systemName: "creditcard.fill")
        paymentMethodIcon.tintColor = .black
        paymentMethodIcon.contentMode = .scaleAspectFit

        oldPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        oldPriceLabel.font = UIFont.systemFont(ofSize: 16)
        oldPriceLabel.textColor = .gray

        let attributeString: NSMutableAttributedString = NSMutableAttributedString()
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: 0))
        oldPriceLabel.attributedText = attributeString

        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.font = UIFont.systemFont(ofSize: 16)
        discountLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // Red color

        alternativePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        alternativePriceLabel.font = UIFont.systemFont(ofSize: 14)
        alternativePriceLabel.textColor = .gray

        priceContainer.addSubview(currentPriceLabel)
        priceContainer.addSubview(paymentMethodIcon)
        priceContainer.addSubview(oldPriceLabel)
        priceContainer.addSubview(discountLabel)
        priceContainer.addSubview(alternativePriceLabel)
        addSubview(priceContainer)

        NSLayoutConstraint.activate([
            priceContainer.topAnchor.constraint(equalTo: topAnchor),
            priceContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            currentPriceLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor, constant: 16),
            currentPriceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor, constant: 16),

            paymentMethodIcon.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            paymentMethodIcon.leadingAnchor.constraint(equalTo: currentPriceLabel.trailingAnchor, constant: 8),
            paymentMethodIcon.widthAnchor.constraint(equalToConstant: 24),
            paymentMethodIcon.heightAnchor.constraint(equalToConstant: 24),

            oldPriceLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            oldPriceLabel.leadingAnchor.constraint(equalTo: paymentMethodIcon.trailingAnchor, constant: 16),

            discountLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: oldPriceLabel.trailingAnchor, constant: 8),

            alternativePriceLabel.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 4),
            alternativePriceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor, constant: 16),
            alternativePriceLabel.bottomAnchor.constraint(equalTo: priceContainer.bottomAnchor, constant: -16)
        ])
    }

    func configure(with pricing: ProductDetail.Pricing) {
        currentPriceLabel.text = pricing.currentPrice

        if pricing.paymentMethod == "Пэй" {
            paymentMethodIcon.image = UIImage(systemName: "creditcard.circle")
        }

        if let oldPrice = pricing.oldPrice {
            let attributedString = NSAttributedString(
                string: oldPrice,
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            oldPriceLabel.attributedText = attributedString
            oldPriceLabel.isHidden = false
        } else {
            oldPriceLabel.isHidden = true
        }

        if let discount = pricing.discountPercentage {
            discountLabel.text = discount
            discountLabel.isHidden = false
        } else {
            discountLabel.isHidden = true
        }

        if let altPrice = pricing.alternativePrice {
            alternativePriceLabel.text = altPrice
            alternativePriceLabel.isHidden = false
        } else {
            alternativePriceLabel.isHidden = true
        }
    }
}
