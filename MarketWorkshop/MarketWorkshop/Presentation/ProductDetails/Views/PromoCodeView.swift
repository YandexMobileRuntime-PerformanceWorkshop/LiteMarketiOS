import UIKit

class PromoCodeView: UIView {
    private let discountLabel = UILabel()
    private let promoCodeInfoLabel = UILabel()
    private let copyButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        layer.cornerRadius = 16

        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        discountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        discountLabel.textColor = .black

        promoCodeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        promoCodeInfoLabel.font = UIFont.systemFont(ofSize: 14)
        promoCodeInfoLabel.textColor = .darkGray
        promoCodeInfoLabel.numberOfLines = 2

        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copyButton.tintColor = .black
        copyButton.backgroundColor = .white
        copyButton.layer.cornerRadius = 16

        addSubview(discountLabel)
        addSubview(promoCodeInfoLabel)
        addSubview(copyButton)

        NSLayoutConstraint.activate([
            discountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            discountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            promoCodeInfoLabel.topAnchor.constraint(equalTo: discountLabel.topAnchor),
            promoCodeInfoLabel.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 16),
            promoCodeInfoLabel.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -16),
            promoCodeInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            copyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            copyButton.widthAnchor.constraint(equalToConstant: 40),
            copyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with promoCode: ProductDetail.PromoCode) {
        discountLabel.text = promoCode.discount

        var promoText = promoCode.code
        if let minOrder = promoCode.minOrder {
            promoText += "\n" + minOrder
        }
        if let expiry = promoCode.expiryDate {
            promoText += " • " + expiry
        }

        promoCodeInfoLabel.text = promoText
    }
}
