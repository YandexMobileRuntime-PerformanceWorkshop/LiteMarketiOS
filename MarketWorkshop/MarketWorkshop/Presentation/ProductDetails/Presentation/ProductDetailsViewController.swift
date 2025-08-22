import UIKit

protocol ProductDetailView: AnyObject {
    func display(product: ProductDetail)
    func displayLoading()
    func displayError(message: String)
}

final class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: ProductDetailPresenterProtocol
    private var productDetail: ProductDetail?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let navigationHeaderView = ProductNavigationHeaderView()
    private let galleryView = ProductGalleryView()
    private let productInfoView = ProductInfoView()
    private let priceView = ProductPriceView()
    private let promoCodeView = PromoCodeView()
    private let sellerView = SellerView()
    private let deliveryView = DeliveryView()
    private let actionButtonsView = ProductActionButtonsView()
    
    private let skeletonView = ProductDetailSkeletonView()
    
    // MARK: - Initialization
    init(presenter: ProductDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCallbacks()
        presenter.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.isHidden = true
        view.addSubview(skeletonView)
        
        navigationHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationHeaderView)
        
        [galleryView, productInfoView, priceView, promoCodeView, sellerView, deliveryView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        actionButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButtonsView)
        
        NSLayoutConstraint.activate([
            navigationHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationHeaderView.heightAnchor.constraint(equalToConstant: 44),
            
            scrollView.topAnchor.constraint(equalTo: navigationHeaderView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionButtonsView.topAnchor, constant: -8),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            galleryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            galleryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            galleryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            productInfoView.topAnchor.constraint(equalTo: galleryView.bottomAnchor, constant: 16),
            productInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor, constant: 16),
            priceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            promoCodeView.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 12),
            promoCodeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            promoCodeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sellerView.topAnchor.constraint(equalTo: promoCodeView.bottomAnchor, constant: 12),
            sellerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sellerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            deliveryView.topAnchor.constraint(equalTo: sellerView.bottomAnchor, constant: 12),
            deliveryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deliveryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deliveryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            actionButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            actionButtonsView.heightAnchor.constraint(equalToConstant: 56),
            
            skeletonView.topAnchor.constraint(equalTo: view.topAnchor),
            skeletonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCallbacks() {
        navigationHeaderView.onBackTapped = {
            self.navigationController?.popViewController(animated: true)
        }
        
        navigationHeaderView.onFavoriteTapped = { [weak self] in
            self?.presenter.toggleFavorite()
        }
    }
}

// MARK: - ProductDetailView Protocol Conformance
extension ProductDetailViewController: ProductDetailView {

    func display(product: ProductDetail) {
        productDetail = product
        
        skeletonView.stopSkeletonAnimation()
        scrollView.isHidden = false
        navigationHeaderView.isHidden = false
        actionButtonsView.isHidden = false

        navigationHeaderView.updateFavoriteState(isFavorite: product.isFavorite)
        galleryView.configure(with: product)
        productInfoView.configure(with: product)
        priceView.configure(with: product.price)
        
        if let promoCode = product.promoCode {
            promoCodeView.configure(with: promoCode)
            promoCodeView.isHidden = false
        } else {
            promoCodeView.isHidden = true
        }
        
        sellerView.configure(with: product.seller)
        deliveryView.configure(with: product.delivery)
        self.presenter.logLCP()
    }
    
    func displayLoading() {
        scrollView.isHidden = true
        navigationHeaderView.isHidden = true
        actionButtonsView.isHidden = true
        skeletonView.startSkeletonAnimation()
    }
    
    func displayError(message: String) {
        skeletonView.stopSkeletonAnimation()
        scrollView.isHidden = false
        navigationHeaderView.isHidden = false
        actionButtonsView.isHidden = false

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
