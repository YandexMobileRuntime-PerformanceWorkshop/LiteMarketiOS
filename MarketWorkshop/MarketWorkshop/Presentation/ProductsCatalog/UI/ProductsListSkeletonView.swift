import UIKit

// MARK: - Products List Skeleton View
final class ProductsListSkeletonView: UIView {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var skeletonCells: [ProductSkeletonCell] = []
    
    private let numberOfColumns = 2
    private let numberOfRows = 4
    private let totalCells = 8
    private let cellSpacing: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeletonLayout()
        createSkeletonCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupSkeletonLayout() {
        backgroundColor = UIColor(white: 0.97, alpha: 1) // Match ProductsViewController background
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false // Disable scrolling for skeleton
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func createSkeletonCells() {
        for _ in 0..<totalCells {
            let skeletonCell = ProductSkeletonCell()
            skeletonCell.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(skeletonCell)
            skeletonCells.append(skeletonCell)
        }
        
        setupSkeletonCellsLayout()
    }
    
    private func setupSkeletonCellsLayout() {
        let availableWidth = UIScreen.main.bounds.width - sectionInsets.left - sectionInsets.right - CGFloat(numberOfColumns - 1) * cellSpacing
        let cellWidth = availableWidth / CGFloat(numberOfColumns)
        let cellHeight = cellWidth * 4/3 + 60 // Image ratio + space for title and price
        
        var constraints: [NSLayoutConstraint] = []
        
        for (index, cell) in skeletonCells.enumerated() {
            let row = index / numberOfColumns
            let column = index % numberOfColumns
            
            constraints.append(cell.widthAnchor.constraint(equalToConstant: cellWidth))
            constraints.append(cell.heightAnchor.constraint(equalToConstant: cellHeight))
            
            if column == 0 {
                constraints.append(cell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sectionInsets.left))
            } else {
                let previousCell = skeletonCells[index - 1]
                constraints.append(cell.leadingAnchor.constraint(equalTo: previousCell.trailingAnchor, constant: cellSpacing))
            }
            
            if row == 0 {
                constraints.append(cell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: sectionInsets.top))
            } else {
                let cellAbove = skeletonCells[index - numberOfColumns]
                constraints.append(cell.topAnchor.constraint(equalTo: cellAbove.bottomAnchor, constant: cellSpacing))
            }
            
            if row == numberOfRows - 1 {
                constraints.append(contentView.bottomAnchor.constraint(greaterThanOrEqualTo: cell.bottomAnchor, constant: sectionInsets.bottom))
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Animation Control
    func startSkeletonAnimation() {
        isHidden = false
        
        skeletonCells.enumerated().forEach { index, cell in
            let delay = Double(index) * 0.15 // Stagger animation start
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                cell.startSkeletonAnimation()
            }
        }
    }
    
    func stopSkeletonAnimation() {
        skeletonCells.forEach { $0.stopSkeletonAnimation() }
        isHidden = true
    }
    
    // MARK: - Layout Updates
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSkeletonLayout()
    }
    
    private func updateSkeletonLayout() {
        guard !skeletonCells.isEmpty else { return }
        
        let availableWidth = bounds.width - sectionInsets.left - sectionInsets.right - CGFloat(numberOfColumns - 1) * cellSpacing
        let cellWidth = availableWidth / CGFloat(numberOfColumns)
        let cellHeight = cellWidth * 4/3 + 60
        
        skeletonCells.forEach { cell in
            cell.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = cellWidth
                } else if constraint.firstAttribute == .height {
                    constraint.constant = cellHeight
                }
            }
        }
    }
}

// MARK: - Factory
final class ProductsListSkeletonViewFactory {
    static func create() -> ProductsListSkeletonView {
        return ProductsListSkeletonView()
    }
}
