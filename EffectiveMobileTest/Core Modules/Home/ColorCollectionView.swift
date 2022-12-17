//
//  ColorCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

protocol ColorCollectionViewProtocol: AnyObject {
    func colorRequest(for indexPath: IndexPath) -> String
    func getColorCount() -> Int
}

final class ColorCollectionView: UIView {
    
    public weak var delegate: ColorCollectionViewProtocol?
    private var colorSelectedCell: Int? = nil
        
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

extension ColorCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension ColorCollectionView {
    func setup() {
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: C.colorCellSize, height: C.colorCellSize)
        layout.minimumLineSpacing = C.cellItemSpace
        return layout
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.id
        )
    }
}

// MARK: - CollectionView DataSource/Delegate

extension ColorCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getColorCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCollectionViewCell.id,
            for: indexPath
        ) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let selectedCell = colorSelectedCell, selectedCell == indexPath.row {
            cell.isSelected = true
        }
        cell.color = delegate?.colorRequest(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        colorSelectedCell = indexPath.row
        collectionView.reloadData()
    }
}

// MARK: - Constants

private extension ColorCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let colorCellSize: CGFloat = 40
        static let cellItemSpace: CGFloat = 18
    }
}

// MARK: - Layout

private extension ColorCollectionView {
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
