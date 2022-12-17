//
//  HeaderView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 10.12.2022.
//

import UIKit

enum HeaderType: String {
    case selectCategory = "Select Category"
    case hotSales = "Hot Sales"
    case bestSeller = "Best Seller"
}

protocol HeaderViewProtocol: AnyObject {
    func didTapRightButton(with type: HeaderType)
}

final class HeaderView: UIView {
    
    public weak var delegate: HeaderViewProtocol?
    private var type: HeaderType?
    
    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.text
        view.font = R.Font.markPro(type: .bold, size: C.titleFontSize)
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(R.Color.peach, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .regular, size: C.buttonFontSize)
        return view
    }()
    
    // MARK: - Init
    
    init(type: HeaderType) {
        self.type = type
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupSubviews()
        setupLayout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension HeaderView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(rightButton)
    }
    
    func setupSubviews() {
        titleLabel.text = type?.rawValue
        rightButton.setTitle(type == .selectCategory ? R.Text.Home.viewAll : R.Text.Home.seeMore , for: .normal)
    }
    
    func addActions() {
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
    }
}

// MARK: - Action

private extension HeaderView {
    @objc func didTapRightButton() {
        guard let type = type else { return }
        delegate?.didTapRightButton(with: type)
    }
}

// MARK: - Constants

private extension HeaderView {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 25
        static let buttonFontSize: CGFloat = 15
        static let titleLabelLeading: CGFloat = 17
        static let rightButtonTrailing: CGFloat = -33
    }
}

// MARK: - Layout

private extension HeaderView {
    func setupLayout() {
        [
            titleLabel,
            rightButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.titleLabelLeading),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.rightButtonTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
