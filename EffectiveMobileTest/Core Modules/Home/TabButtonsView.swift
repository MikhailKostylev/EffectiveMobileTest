//
//  TabButtonsView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

final class TabButtonsView: UIStackView {
        
    // MARK: - Subviews
    
    private let shopButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.shop, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .bold, size: C.buttonLabelFontSize)
        view.setTitleColor(R.Color.night, for: .normal)
        view.tag = 0
        return view
    }()
    
    private let detailsButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.details, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .regular, size: C.buttonLabelFontSize)
        view.setTitleColor(.gray, for: .normal)
        view.tag = 1
        return view
    }()
    
    private let featuresButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.features, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .regular, size: C.buttonLabelFontSize)
        view.setTitleColor(.gray, for: .normal)
        view.tag = 2
        return view
    }()
    
    private let shopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.buttonIndicatorSpacing
        return stackView
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.buttonIndicatorSpacing
        return stackView
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.buttonIndicatorSpacing
        return stackView
    }()
    
    private let shopIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Color.peach
        view.layer.cornerRadius = C.indicatorCornerRadius
        view.isHidden = false
        return view
    }()
    
    private let detailsIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Color.peach
        view.layer.cornerRadius = C.indicatorCornerRadius
        view.isHidden = true
        return view
    }()
    
    private let featuresIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Color.peach
        view.layer.cornerRadius = C.indicatorCornerRadius
        view.isHidden = true
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
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension TabButtonsView {
    func setup() {
        backgroundColor = .white
        alignment = .fill
        distribution = .equalCentering
    }
    
    func addSubviews() {
        shopStackView.addArrangedSubview(shopButton)
        shopStackView.addArrangedSubview(shopIndicatorView)
        detailsStackView.addArrangedSubview(detailsButton)
        detailsStackView.addArrangedSubview(detailsIndicatorView)
        featuresStackView.addArrangedSubview(featuresButton)
        featuresStackView.addArrangedSubview(featuresIndicatorView)
        
        [
            shopStackView,
            detailsStackView,
            featuresStackView
        ].forEach { addArrangedSubview($0) }
    }
    
    func setupButtonsToDefault() {
        [
            shopButton,
            detailsButton,
            featuresButton
        ].forEach {
            $0.titleLabel?.font = R.Font.markPro(type: .regular, size: C.buttonLabelFontSize)
            $0.setTitleColor(.gray, for: .normal)
        }
    }
    
    func setupIndicatorsToDefault() {
        [
            shopIndicatorView,
            detailsIndicatorView,
            featuresIndicatorView
        ].forEach { $0.isHidden = true }
    }
    
    func addActions() {
        [
            shopButton,
            detailsButton,
            featuresButton
        ].forEach { $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside) }
    }
}

// MARK: - Action

private extension TabButtonsView {
    @objc func didTapButton(_ sender: UIButton) {
        setupButtonsToDefault()
        setupIndicatorsToDefault()
        
        switch sender.tag {
        case 2:
            featuresButton.titleLabel?.font = R.Font.markPro(type: .bold, size: C.buttonLabelFontSize)
            featuresButton.setTitleColor(R.Color.night, for: .normal)
            featuresIndicatorView.isHidden = false
        case 1:
            detailsButton.titleLabel?.font = R.Font.markPro(type: .bold, size: C.buttonLabelFontSize)
            detailsButton.setTitleColor(R.Color.night, for: .normal)
            detailsIndicatorView.isHidden = false
        default:
            shopButton.titleLabel?.font = R.Font.markPro(type: .bold, size: C.buttonLabelFontSize)
            shopButton.setTitleColor(R.Color.night, for: .normal)
            shopIndicatorView.isHidden = false
        }
    }
}

// MARK: - Constants

private extension TabButtonsView {
    typealias C = Constants
    
    enum Constants {
        static let buttonLabelFontSize: CGFloat = 20
        static let buttonIndicatorSpacing: CGFloat = 5
        static let indicatorHeight: CGFloat = 3
        static var indicatorCornerRadius: CGFloat {
            indicatorHeight / 2
        }
    }
}

// MARK: - Layout

private extension TabButtonsView {
    func setupLayout() {
        let constraints = [
            shopIndicatorView.heightAnchor.constraint(equalToConstant: C.indicatorHeight),
            detailsIndicatorView.heightAnchor.constraint(equalToConstant: C.indicatorHeight),
            featuresIndicatorView.heightAnchor.constraint(equalToConstant: C.indicatorHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
