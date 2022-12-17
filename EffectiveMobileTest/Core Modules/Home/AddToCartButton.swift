//
//  AddToCartButton.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

protocol AddToCartButtonProtocol: AnyObject {
    func getTitleForButton()
}

final class AddToCartButton: UIButton {
        
    // MARK: - Subviews
    
    private let nameTitleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.addToCart
        view.textColor = .white
        view.font = R.Font.markPro(type: .bold, size: C.labelFontSize)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = R.Font.markPro(type: .bold, size: C.labelFontSize)
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension AddToCartButton {
    func setup() {
        backgroundColor = R.Color.peach
        layer.cornerRadius = C.selfCornerRadius
        layer.masksToBounds = true
    }
    
    func addSubviews() {
        [
            nameTitleLabel,
            priceLabel
        ].forEach { addSubview($0) }
    }
    
    func setupSubviews() {
        
    }
}

// MARK: - Public

extension AddToCartButton {
    public func setPriceLabel(with text: String?) {
        priceLabel.text = text
    }
}

// MARK: - Constants

private extension AddToCartButton {
    typealias C = Constants
    
    enum Constants {
        static let labelFontSize: CGFloat = 20
        static let selfCornerRadius: CGFloat = 10
        static let nameTitleLabelLeading: CGFloat = 45
        static let priceLabelTrailing: CGFloat = -38
    }
}

// MARK: - Layout

private extension AddToCartButton {
    func setupLayout() {
        [
            nameTitleLabel,
            priceLabel
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            nameTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.nameTitleLabelLeading),
            
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.priceLabelTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
