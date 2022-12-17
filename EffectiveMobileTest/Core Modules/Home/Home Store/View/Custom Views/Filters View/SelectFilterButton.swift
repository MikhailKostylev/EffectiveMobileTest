//
//  SelectFilterButton.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 14.12.2022.
//

import UIKit

final class SelectFilterButton: UIButton {
        
    // MARK: - Subviews
    
    private let filterTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        return view
    }()
    
    private let downArrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Home.downArrowBig
        view.tintColor = R.Color.grayIcon
        return view
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension SelectFilterButton {
    func setup() {
        backgroundColor = .white
        layer.cornerRadius = C.selfCornerRadius
        layer.borderColor = R.Color.grayBorder.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
    
    func addSubviews() {
        [
            filterTitleLabel,
            downArrowImageView
        ].forEach { addSubview($0) }
    }
}

// MARK: - Public

extension SelectFilterButton {
    public func setLabel(with text: String?) {
        filterTitleLabel.text = text
    }
}

// MARK: - Constants

private extension SelectFilterButton {
    typealias C = Constants
    
    enum Constants {
        static let selfCornerRadius: CGFloat = 5
        static let titleFontSize: CGFloat = 18
        static let titleLeading: CGFloat = 14
        static let imageViewTrailing: CGFloat = -20
    }
}

// MARK: - Layout

private extension SelectFilterButton {
    func setupLayout() {
        [
            filterTitleLabel,
            downArrowImageView
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            filterTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.titleLeading),
            
            downArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            downArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.imageViewTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
