//
//  CartNavBarView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import UIKit

protocol CartNavBarViewProtocol: AnyObject {
    func didTapBack()
    func didTapLocation()
}

final class CartNavBarView: UIView {
    
    public weak var delegate: CartNavBarViewProtocol?
    
    // MARK: - Subviews
    
    private let backButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.leftArrow, for: .normal)
        view.backgroundColor = R.Color.night
        view.tintColor = .white
        view.layer.cornerRadius = C.buttonCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let addAddressLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.addAddress
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        return view
    }()
    
    private let addAddressButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.locationPin, for: .normal)
        view.backgroundColor = R.Color.peach
        view.tintColor = .white
        view.layer.cornerRadius = C.buttonCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupLayout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CartNavBarView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        [
            backButton,
            addAddressLabel,
            addAddressButton
        ].forEach { addSubview($0) }
    }
    
    func addActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        addAddressButton.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
    }
}

// MARK: - Action

private extension CartNavBarView {
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    @objc func didTapLocation() {
        delegate?.didTapLocation()
    }
}

// MARK: - Constants

private extension CartNavBarView {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 15
        static let buttonCornerRadius: CGFloat = 10
        static let backButtonSize: CGFloat = 37
        static let backButtonLeading: CGFloat = 42
        static let addAddressButtonSize: CGFloat = 37
        static let addAddressButtonTrailing: CGFloat = -46
        static let addAddressLabelTrailing: CGFloat = -9
    }
}

// MARK: - Layout

private extension CartNavBarView {
    func setupLayout() {
        [
            backButton,
            addAddressLabel,
            addAddressButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.backButtonLeading),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: C.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: C.backButtonSize),
            
            addAddressButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addAddressButton.widthAnchor.constraint(equalToConstant: C.addAddressButtonSize),
            addAddressButton.heightAnchor.constraint(equalToConstant: C.addAddressButtonSize),
            addAddressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.addAddressButtonTrailing),
            
            addAddressLabel.centerYAnchor.constraint(equalTo: addAddressButton.centerYAnchor),
            addAddressLabel.trailingAnchor.constraint(equalTo: addAddressButton.leadingAnchor, constant: C.addAddressLabelTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
