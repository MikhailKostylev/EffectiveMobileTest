//
//  HotSalesCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 13.12.2022.
//

import UIKit

protocol HotSalesCollectionViewProtocol: AnyObject {
    func hotSalesRequest(for indexPath: IndexPath) -> HomeStore?
    func getHotSalesItemCount() -> Int
}

final class HotSalesCollectionView: UIView {
    
    public weak var delegate: HotSalesCollectionViewProtocol?
        
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

extension HotSalesCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension HotSalesCollectionView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: .zero, left: C.itemLeftInset, bottom: .zero, right: C.itemRightInset)
        layout.itemSize = CGSize(width: C.hotSalesCellWidth, height: C.hotSalesCellHeight)
        layout.minimumLineSpacing = C.cellItemSpace
        return layout
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = R.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            HotSalesCollectionViewCell.self,
            forCellWithReuseIdentifier: HotSalesCollectionViewCell.id
        )
    }
}

// MARK: - CollectionView DataSource/Delegate

extension HotSalesCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getHotSalesItemCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HotSalesCollectionViewCell.id,
            for: indexPath
        ) as? HotSalesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = delegate?.hotSalesRequest(for: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - Cell Delegate

extension HotSalesCollectionView: HotSalesCellProtocol {
    func didTapBuy(at itemID: Int, isBuy: Bool) {
        print("\(#function)\(itemID)\(isBuy)")
    }
}

// MARK: - Constants

private extension HotSalesCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let itemLeftInset: CGFloat = 21
        static let itemRightInset: CGFloat = 15
        static let hotSalesCellHeight: CGFloat = 182
        static var hotSalesCellWidth: CGFloat {
            R.Screen.size.width - itemLeftInset - itemRightInset
        }
        static var cellItemSpace: CGFloat {
            itemLeftInset + itemRightInset
        }
        
    }
}

// MARK: - Layout

private extension HotSalesCollectionView {
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
