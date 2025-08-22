import UIKit
import DI


final class ProductsViewController: UIViewController {
    // MARK: - Properties
    private var presenter: ProductsPresenterProtocol!
    private var products: [Product] = []
    private var isPaginationLoading = false
    private var isRefreshing = false
    
    private lazy var productDetailsAssembly: ProductDetailsAssembly = AssemblyActivator.shared.resolve()

    private var searchContainer: UIView!
    private var searchTextField: UITextField!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var cellSizeCache: [IndexPath: CGSize] = [:]
    private var rowHeights: [Int: CGFloat] = [:]
    
    private let performanceManager = PerformanceMetricManager.shared

    private lazy var categoriesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let skeletonView = ProductsListSkeletonView()

    private let screenTracker = MVIScreenAnalytics(creationTime: .fromAppStart)

    // MARK: - Constructor
    init(presenter: ProductsPresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.presenter.view = self
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)

        setupCustomSearchBar()

        setupCategories()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            categoriesScrollView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 12),
            categoriesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesScrollView.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: categoriesScrollView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
        collectionView.register(ProductSkeletonCell.self, forCellWithReuseIdentifier: ProductSkeletonCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.isHidden = true
        view.addSubview(skeletonView)
        
        NSLayoutConstraint.activate([
            skeletonView.topAnchor.constraint(equalTo: categoriesScrollView.bottomAnchor, constant: 8),
            skeletonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skeletonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skeletonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCategories() {
        let categories = ["Для вас", "Ниже рынка", "Ultima", "Одежда", "Дом"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for (index, category) in categories.enumerated() {
            let pill = UIButton()
            pill.setTitle(category, for: .normal)
            pill.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            pill.backgroundColor = index == 0 ? UIColor.darkGray : UIColor(white: 0.9, alpha: 1)
            pill.setTitleColor(index == 0 ? .white : .black, for: .normal)
            pill.layer.cornerRadius = 16
            pill.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            stackView.addArrangedSubview(pill)
        }

        categoriesScrollView.addSubview(stackView)
        view.addSubview(categoriesScrollView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: categoriesScrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: categoriesScrollView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: categoriesScrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: categoriesScrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func setupCustomSearchBar() {
        let searchContainer = UIView()
        searchContainer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) // Light gray
        searchContainer.layer.cornerRadius = 20
        searchContainer.translatesAutoresizingMaskIntoConstraints = false

        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.translatesAutoresizingMaskIntoConstraints = false

        let searchTextField = UITextField()
        searchTextField.placeholder = "Найти товары"
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .clear
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.returnKeyType = .search
        searchTextField.isUserInteractionEnabled = false
        let filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        filterButton.tintColor = .gray
        filterButton.translatesAutoresizingMaskIntoConstraints = false

        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        searchContainer.addSubview(filterButton)
        view.addSubview(searchContainer)

        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainer.heightAnchor.constraint(equalToConstant: 40),

            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),

            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

            filterButton.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            filterButton.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 24),
            filterButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        self.searchContainer = searchContainer
        self.searchTextField = searchTextField
    }
    
    @objc private func refreshData() {
        isRefreshing = true
        presenter.loadProducts(refresh: true)
    }
}

// MARK: - ProductsView Protocol Conformance
extension ProductsViewController: ProductsView {
    func show(products: [Product]) {
        self.products = products
        cellSizeCache.removeAll()
        rowHeights.removeAll()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.collectionView.refreshControl?.isRefreshing == true {
                self.collectionView.refreshControl?.endRefreshing()
            }
            self.isRefreshing = false
            DispatchQueue.main.async {
                self.screenTracker.logLCP(screen: "Catalog")
            }
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            print("Error: \(error.localizedDescription)")
            
            if self.collectionView.refreshControl?.isRefreshing == true {
                self.collectionView.refreshControl?.endRefreshing()
            }
            self.isRefreshing = false
        }
    }
    
    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            // Don't show skeleton during pull-to-refresh, only for initial loading
            if self.isRefreshing {
                return
            }
            
            if isLoading {
                self.collectionView.isHidden = true
                self.skeletonView.startSkeletonAnimation()
            } else {
                self.skeletonView.stopSkeletonAnimation()
                self.collectionView.isHidden = false
            }
        }
    }
    
    func showPaginationLoading(_ isLoading: Bool) {
        isPaginationLoading = isLoading
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count + (isPaginationLoading ? 1 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item >= products.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
            cell.startLoading()
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
        cell.configure(with: products[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= products.count {
            return CGSize(width: collectionView.bounds.width - 32, height: 80)
        }
        
        let width = (view.frame.width - 48) / 2
        let height = width * 4/3 + 60
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < products.count else { return }
        let mviScreenAnalytics = MVIScreenAnalytics(creationTime: .fromScreenCreation(timestamp: .now()))
        let selectedProduct = products[indexPath.item]

        presenter.sendAnalytics(for: selectedProduct, at: indexPath)

        let detailVC = productDetailsAssembly.createProductDetailsModule(
            for: selectedProduct.id,
            mviScreenAnalytics: mviScreenAnalytics
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Synchronous Analytics


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        performanceManager.start(measureName: "catalog_scroll")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            performanceManager.stop(name: "catalog_scroll", responseInfo: [:])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        performanceManager.stop(name: "catalog_scroll", responseInfo: [:])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        let itemWidth = (view.frame.width - 48) / 2
        let itemHeight = itemWidth * 4/3 + 60

        if offsetY > contentHeight - frameHeight - itemHeight * 2 {
            presenter.loadNextPageIfNeeded()
        }
    }
}

