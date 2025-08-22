import UIKit

class ProductActionButtonsView: UIView {
    private let buyNowButton = UIButton()
    private let addToCartButton = UIButton()

    var onBuyNowTapped: (() -> Void)?
    var onAddToCartTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        buyNowButton.translatesAutoresizingMaskIntoConstraints = false
        buyNowButton.setTitle("Купить сейчас", for: .normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        buyNowButton.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        buyNowButton.setTitleColor(.black, for: .normal)
        buyNowButton.layer.cornerRadius = 20
        buyNowButton.addTarget(self, action: #selector(buyNowTapped), for: .touchUpInside)

        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.setTitle("В корзину", for: .normal)
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addToCartButton.backgroundColor = UIColor(red: 1.0, green: 0.85, blue: 0.2, alpha: 1.0) // Yellow
        addToCartButton.setTitleColor(.black, for: .normal)
        addToCartButton.layer.cornerRadius = 20
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)

        addSubview(buyNowButton)
        addSubview(addToCartButton)

        NSLayoutConstraint.activate([
            buyNowButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            buyNowButton.topAnchor.constraint(equalTo: topAnchor),
            buyNowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            buyNowButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.42),

            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addToCartButton.topAnchor.constraint(equalTo: topAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addToCartButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55)
        ])
    }

    @objc private func buyNowTapped() {
        onBuyNowTapped?()
    }

    @objc private func addToCartTapped() {
        onAddToCartTapped?()
    }
}
