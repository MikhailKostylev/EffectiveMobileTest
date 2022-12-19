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
    private var imageBannerSelectedCell = 0
        
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
        layout.minimumLineSpacing = C.cellItemSpace
        layout.itemSize = CGSize(width: C.imageBannerCellWidth, height: C.imageBannerCellHeight)
        layout.sectionInset = UIEdgeInsets(
            top: C.itemTopInset,
            left: C.itemLeftInset,
            bottom: C.itemBottomInset,
            right: C.itemRightInset
        )
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
        if imageBannerSelectedCell == indexPath.row {
            cell.isSelected = true
        }
        cell.imageUrl = delegate?.imageBannerRequest(for: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageBannerSelectedCell = Int((scrollView.contentOffset.x + C.imageBannerCellWidth / 2) / C.imageBannerCellWidth)
        collectionView.reloadData()
    }
}

// MARK: - Constants

private extension ImageBannerCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let cellItemSpace: CGFloat = 30
        static let itemTopInset: CGFloat = 14
        static let itemBottomInset: CGFloat = 14
        static var itemLeftInset: CGFloat {
            (R.Screen.size.width - imageBannerCellWidth) / 2
        }
        
        static var itemRightInset: CGFloat {
            (R.Screen.size.width - imageBannerCellWidth) / 2
        }
        
        static var imageBannerCellWidth: CGFloat {
            R.Screen.size.width / 1.56
        }
        
        static var imageBannerCellHeight: CGFloat {
            R.Screen.size.height / 3.5
        }
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
