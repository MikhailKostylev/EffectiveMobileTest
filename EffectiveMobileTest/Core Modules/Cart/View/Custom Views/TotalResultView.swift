//
//  TotalResultView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import UIKit

protocol TotalResultViewProtocol: AnyObject {
    func didTapCheckout()
}

final class TotalResultView: UIView {
    
    public weak var delegate: TotalResultViewProtocol?
    
    // MARK: - Subviews
    
    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = R.Color.bigDivider
        return view
    }()
    
    private let totalTitleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.total
        view.textColor = .white
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        return view
    }()
    
    private let deliveryTitleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.delivery
        view.textColor = .white
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        return view
    }()
    
    private let totalResultLabel: UILabel = {
        let view = UILabel()
        view.text = "$6,000 us"
        view.textColor = .white
        view.font = R.Font.markPro(type: .bold, size: C.titleFontSize)
        return view
    }()
    
    private let deliveryResultLabel: UILabel = {
        let view = UILabel()
        view.text = "Free"
        view.textColor = .white
        view.font = R.Font.markPro(type: .bold, size: C.titleFontSize)
        return view
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = R.Color.divider
        return view
    }()
    
    private let checkoutButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = R.Color.peach
        view.setTitle(R.Text.Home.checkout, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .bold, size: C.checkoutButtonFontSize)
        view.layer.cornerRadius = C.checkoutButtonCornerRadius
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

private extension TotalResultView {
    func setup() {
        backgroundColor = R.Color.night
    }
    
    func addSubviews() {
        [
            topDivider,
            totalTitleLabel,
            deliveryTitleLabel,
            totalResultLabel,
            deliveryResultLabel,
            bottomDivider,
            checkoutButton
        ].forEach { addSubview($0) }
    }
    
    func addActions() {
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
    }
}

// MARK: - Action

private extension TotalResultView {
    @objc func didTapCheckout() {
        delegate?.didTapCheckout()
    }
}

// MARK: - Public

extension TotalResultView {
    func setTotalResult(with price: Int) {
        totalResultLabel.text = price.convertToDollarsUS()
    }
    
    func setDeliveryResult(with delivery: String) {
        deliveryResultLabel.text = delivery
    }
}

// MARK: - Constants

private extension TotalResultView {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 15
        static let checkoutButtonFontSize: CGFloat = 20
        static let checkoutButtonCornerRadius: CGFloat = 10
        
        static let topDividerLeading: CGFloat = 4
        static let topDividerTrailing: CGFloat = -4
        static let topDividerHeight: CGFloat = 2
        static let totalTitleLabelTop: CGFloat = 15
        static let totalTitleLabelLeading: CGFloat = 55
        static let deliveryResultLabelTop: CGFloat = 12
        static let resultLabelLeading: CGFloat = -108
        static let dividerTop: CGFloat = 26
        static let dividerLeading: CGFloat = 4
        static let dividerTrailing: CGFloat = -4
        static let dividerHeight: CGFloat = 1
        static let checkoutButtonLeading: CGFloat = 44
        static let checkoutButtonTrailing: CGFloat = -44
        static let checkoutButtonHeight: CGFloat = 54
        static let checkoutButtonBottom: CGFloat = -44
    }
}

// MARK: - Layout

private extension TotalResultView {
    func setupLayout() {
        [
            topDivider,
            totalTitleLabel,
            deliveryTitleLabel,
            totalResultLabel,
            deliveryResultLabel,
            bottomDivider,
            checkoutButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            topDivider.topAnchor.constraint(equalTo: topAnchor),
            topDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.topDividerLeading),
            topDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.topDividerTrailing),
            topDivider.heightAnchor.constraint(equalToConstant: C.topDividerHeight),
            
            totalTitleLabel.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: C.totalTitleLabelTop),
            totalTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.totalTitleLabelLeading),
            
            deliveryTitleLabel.topAnchor.constraint(equalTo: totalTitleLabel.bottomAnchor, constant: C.deliveryResultLabelTop),
            deliveryTitleLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.leadingAnchor),
            
            totalResultLabel.centerYAnchor.constraint(equalTo: totalTitleLabel.centerYAnchor),
            totalResultLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: C.resultLabelLeading),
            
            deliveryResultLabel.centerYAnchor.constraint(equalTo: deliveryTitleLabel.centerYAnchor),
            deliveryResultLabel.leadingAnchor.constraint(equalTo: totalResultLabel.leadingAnchor),
            
            bottomDivider.topAnchor.constraint(equalTo: deliveryResultLabel.bottomAnchor, constant: C.dividerTop),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.dividerLeading),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.dividerTrailing),
            bottomDivider.heightAnchor.constraint(equalToConstant: C.dividerHeight),
            
            checkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.checkoutButtonLeading),
            checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.checkoutButtonTrailing),
            checkoutButton.heightAnchor.constraint(equalToConstant: C.checkoutButtonHeight),
            checkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: C.checkoutButtonBottom),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
