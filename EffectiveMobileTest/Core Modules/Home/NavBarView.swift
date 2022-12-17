//
//  NavBarView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

protocol NavBarViewProtocol: AnyObject {
    func didTapBack()
    func didTapBasket()
}

final class NavBarView: UIView {
    
    public weak var delegate: NavBarViewProtocol?
    
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
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.productDetails
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        return view
    }()
    
    private let basketButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.productBasket, for: .normal)
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

private extension NavBarView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        [
            backButton,
            titleLabel,
            basketButton
        ].forEach { addSubview($0) }
    }
    
    func addActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        basketButton.addTarget(self, action: #selector(didTapBasket), for: .touchUpInside)
    }
}

// MARK: - Action

private extension NavBarView {
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    @objc func didTapBasket() {
        delegate?.didTapBasket()
    }
}

// MARK: - Constants

private extension NavBarView {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 18
        static let buttonCornerRadius: CGFloat = 10
        static let backButtonSize: CGFloat = 37
        static let backButtonLeading: CGFloat = 42
        static let basketButtonSize: CGFloat = 37
        static let basketButtonTrailing: CGFloat = -35
    }
}

// MARK: - Layout

private extension NavBarView {
    func setupLayout() {
        [
            backButton,
            titleLabel,
            basketButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.backButtonLeading),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: C.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: C.backButtonSize),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            basketButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            basketButton.widthAnchor.constraint(equalToConstant: C.basketButtonSize),
            basketButton.heightAnchor.constraint(equalToConstant: C.basketButtonSize),
            basketButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.basketButtonTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
