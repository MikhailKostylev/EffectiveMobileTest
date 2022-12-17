//
//  BestSellerCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 13.12.2022.
//

import UIKit

protocol BestSellerCollectionViewProtocol: AnyObject {
    func bestSellerRequest(for indexPath: IndexPath) -> BestSeller?
    func getBestSellerItemCount() -> Int
    func didTapBestSeller(at itemID: Int)
}

final class BestSellerCollectionView: UIView {
    
    public weak var delegate: BestSellerCollectionViewProtocol?
        
    // MARK: - Subviews
    
    private var collectionView: UICollectionView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        setupCollectionView()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Public

extension BestSellerCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension BestSellerCollectionView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: C.itemTopInset, left: C.itemLeftInset, bottom: C.itemBottomInset, right: C.itemRightInset)
        layout.itemSize = CGSize(width: C.bestSellerCellWidth, height: C.bestSellerCellHeight)
        layout.minimumLineSpacing = C.cellLineSpace
        layout.minimumInteritemSpacing = C.cellItemSpace
        return layout
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.backgroundColor = R.Color.background
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            BestSellerCollectionViewCell.self,
            forCellWithReuseIdentifier: BestSellerCollectionViewCell.id
        )
    }
}

// MARK: - CollectionView DataSource/Delegate

extension BestSellerCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getBestSellerItemCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BestSellerCollectionViewCell.id,
            for: indexPath
        ) as? BestSellerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = delegate?.bestSellerRequest(for: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - Cell Delegate

extension BestSellerCollectionView: BestSellerCellProtocol {
    func toggleFavorite(at itemID: Int, isFavorite: Bool) {
        print("\(#function)\(itemID)\(isFavorite)")
    }
    
    func didTapItem(at itemID: Int) {
        delegate?.didTapBestSeller(at: itemID)
    }
}

// MARK: - Constants

private extension BestSellerCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let itemTopInset: CGFloat = 17
        static let itemLeftInset: CGFloat = 17
        static let itemRightInset: CGFloat = 21
        static let itemBottomInset: CGFloat = 20
        static let cellLineSpace: CGFloat = 14
        static var cellItemSpace: CGFloat = 12
        static let bestSellerCellHeight: CGFloat = 227
        static var bestSellerCellWidth: CGFloat {
            (R.Screen.size.width - itemLeftInset - itemRightInset - cellLineSpace) / 2 
        }
    }
}

// MARK: - Layout

private extension BestSellerCollectionView {
    func setupLayout() {
        [
            collectionView
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
