//
//  CapacityCollectionView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 17.12.2022.
//

import UIKit

protocol CapacityCollectionViewProtocol: AnyObject {
    func capacityRequest(for indexPath: IndexPath) -> String
    func getCapacityCount() -> Int
}

final class CapacityCollectionView: UIView {
    
    public weak var delegate: CapacityCollectionViewProtocol?
    private var capacitySelectedCell: Int? = 0
        
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

extension CapacityCollectionView {
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Setups

private extension CapacityCollectionView {
    func setup() {
        backgroundColor = .white
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: C.capacityCellWidth, height: C.capacityCellHeight)
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
            CapacityCollectionViewCell.self,
            forCellWithReuseIdentifier: CapacityCollectionViewCell.id
        )
    }
}

// MARK: - CollectionView DataSource/Delegate

extension CapacityCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getCapacityCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CapacityCollectionViewCell.id,
            for: indexPath
        ) as? CapacityCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let selectedCell = capacitySelectedCell, selectedCell == indexPath.row {
            cell.isSelected = true
        }
        cell.text = delegate?.capacityRequest(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        capacitySelectedCell = indexPath.row
        collectionView.reloadData()
    }
}

// MARK: - Constants

private extension CapacityCollectionView {
    typealias C = Constants
    
    enum Constants {
        static let capacityCellWidth: CGFloat = 70
        static let capacityCellHeight: CGFloat = 30
        static let cellItemSpace: CGFloat = 20
    }
}

// MARK: - Layout

private extension CapacityCollectionView {
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
