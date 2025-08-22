import UIKit

class DeliveryView: UIView {
    private let titleLabel = UILabel()
    private let optionsStackView = UIStackView()

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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "Доставка Маркета"

        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.distribution = .fillEqually

        addSubview(titleLabel)
        addSubview(optionsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            optionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func configure(with delivery: ProductDetail.Delivery) {
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for option in delivery.options {
            let optionView = createDeliveryOptionView(with: option)
            optionsStackView.addArrangedSubview(optionView)
        }
    }

    private func createDeliveryOptionView(with option: ProductDetail.DeliveryOption) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let radioButton = UIView()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.backgroundColor = .white
        radioButton.layer.borderWidth = 2
        radioButton.layer.borderColor = option.isSelected ? UIColor.systemBlue.cgColor : UIColor.lightGray.cgColor
        radioButton.layer.cornerRadius = 10

        let selectedIndicator = UIView()
        selectedIndicator.translatesAutoresizingMaskIntoConstraints = false
        selectedIndicator.backgroundColor = .systemBlue
        selectedIndicator.layer.cornerRadius = 6
        selectedIndicator.isHidden = !option.isSelected

        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dateLabel.textColor = .black
        dateLabel.text = option.date

        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .gray
        detailsLabel.text = option.details

        container.addSubview(radioButton)
        radioButton.addSubview(selectedIndicator)
        container.addSubview(dateLabel)
        container.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            radioButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 20),
            radioButton.heightAnchor.constraint(equalToConstant: 20),

            selectedIndicator.centerXAnchor.constraint(equalTo: radioButton.centerXAnchor),
            selectedIndicator.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor),
            selectedIndicator.widthAnchor.constraint(equalToConstant: 12),
            selectedIndicator.heightAnchor.constraint(equalToConstant: 12),

            dateLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            dateLabel.topAnchor.constraint(equalTo: container.topAnchor),

            detailsLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            detailsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            detailsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
}
