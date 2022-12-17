//
//  CapacityCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 17.12.2022.
//

import UIKit

final class CapacityCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: CapacityCollectionViewCell.self)
    
    public var text: String! {
        didSet {
            configureUI()
        }
    }
        
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.grayText
        view.font = R.Font.markPro(type: .bold, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CapacityCollectionViewCell {
    func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = C.capacityCellCornerRadius
        contentView.layer.masksToBounds = true
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func configureUI() {
        contentView.backgroundColor = isSelected ? R.Color.peach : .white
        titleLabel.textColor = isSelected ? .white : .gray
        if let text = text {
            titleLabel.text = isSelected ? "\(text) GB" : "\(text) gb"
        }
    }
}

// MARK: - Constants

private extension CapacityCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 13
        static let capacityCellCornerRadius: CGFloat = 10
    }
}

// MARK: - Layout

private extension CapacityCollectionViewCell {
    func setupLayout() {
        titleLabel.prepareForAutoLayout()
        
        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
