//
//  CategoryCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 11.12.2022.
//

import UIKit

protocol CategoryCollectionViewProtocol: AnyObject {
    func categoryRequest(for indexPath: IndexPath) -> CategoryCellViewModelProtocol
    func getCategoryItemCount() -> Int
    func didTapCell(with indexPath: IndexPath)
}

final class CategoryCollectionView: UIView {
    
    public weak var delegate: CategoryCollectionViewProtocol?
        
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

extension CategoryCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension CategoryCollectionView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: .zero, left: C.itemLeftPadding, bottom: .zero, right: C.itemRightPadding)
        layout.itemSize = CGSize(width: C.categoryCellWidth, height: C.categoryCellHeight)
        layout.minimumLineSpacing = C.cellItemSpace
        return layout
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = R.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.id
        )
    }
}

// MARK: - CollectionView DataSource/Delegate

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getCategoryItemCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.id,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = delegate?.categoryRequest(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didTapCell(with: indexPath)
    }
}

// MARK: - Constants

private extension CategoryCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let itemLeftPadding: CGFloat = 27
        static let itemRightPadding: CGFloat = 27
        static let categoryCellWidth: CGFloat = 71
        static let categoryCellHeight: CGFloat = 113
        static let cellItemSpace: CGFloat = 23
    }
}

// MARK: - Layout

private extension CategoryCollectionView {
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

