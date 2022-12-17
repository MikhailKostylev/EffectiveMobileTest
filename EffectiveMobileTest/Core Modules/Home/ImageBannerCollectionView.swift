//
//  ImageBannerCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 17.12.2022.
//

import UIKit

protocol ImageBannerCollectionViewProtocol: AnyObject {
    func imageBannerRequest(for indexPath: IndexPath) -> String
    func getImageBannerCount() -> Int
}

final class ImageBannerCollectionView: UIView {
    
    public weak var delegate: ImageBannerCollectionViewProtocol?
    private var imageBannerSelectedCell: Int? = nil
        
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

extension ImageBannerCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension ImageBannerCollectionView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: C.imageBannerCellWidth, height: C.imageBannerCellHeight)
        layout.sectionInset = UIEdgeInsets(top: .zero, left: C.itemLeftInset, bottom: .zero, right: C.itemRightInset)
        layout.minimumLineSpacing = C.cellItemSpace
        return layout
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.backgroundColor = R.Color.background
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ImageBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageBannerCollectionViewCell.id
        )
    }
}

// MARK: - Public

extension ImageBannerCollectionView {
    public func setupSubviews(with viewModel: ProductDetailsModel) {
        collectionView?.reloadData()
    }
}

// MARK: - CollectionView DataSource/Delegate

extension ImageBannerCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getImageBannerCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageBannerCollectionViewCell.id,
            for: indexPath
        ) as? ImageBannerCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let selectedCell = imageBannerSelectedCell, selectedCell == indexPath.row {
            cell.isSelected = true
        }
        cell.imageUrl = delegate?.imageBannerRequest(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        imageBannerSelectedCell = indexPath.row
        collectionView.reloadData()
    }
}

// MARK: - Constants

private extension ImageBannerCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let itemLeftInset: CGFloat = 70
        static let itemRightInset: CGFloat = 70
        static let imageBannerCellWidth: CGFloat = 266
        static var imageBannerCellHeight: CGFloat {
            R.Screen.size.height / 3
        } //335
        static let cellItemSpace: CGFloat = 30
    }
}

// MARK: - Layout

private extension ImageBannerCollectionView {
    func setupLayout() {
        collectionView.prepareForAutoLayout()
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
