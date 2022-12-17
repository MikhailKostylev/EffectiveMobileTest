//
//  TabBarView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 05.12.2022.
//

import UIKit

protocol TabBarViewProtocol: AnyObject {
    func selectTabWith(index: Int)
}

final class TabBarView: UIView {
    
    // MARK: - Subviews
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let homeItem = TabItemView(with: .home, index: 0)
    private let basketItem = TabItemView(with: .basket, index: 1)
    private let favoritesItem = TabItemView(with: .favorites, index: 2)
    private let profileItem = TabItemView(with: .profile, index: 3)
    
    // MARK: - Properties
    
    public weak var delegate: TabBarViewProtocol?
    private var selectedItemIndex = Constants.startTabIndex
    private lazy var customItemViews: [TabItemView] = [
        homeItem,
        basketItem,
        favoritesItem,
        profileItem
    ]
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupHierarchy()
        setupLayout()
        setupTabBarView()
        selectItem(index: selectedItemIndex)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Constants

private extension TabBarView {
    enum Constants {
        static let startTabIndex = 0
        static let tabBarViewCornerRadius: CGFloat = 30
        static let stackLeading: CGFloat = 67
        static let stackTrailing: CGFloat = -67
    }
}

// MARK: - Setups

private extension TabBarView {
    func setupHierarchy() {
        addSubview(stackView)
        customItemViews.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupLayout() {
        stackView.prepareForAutoLayout()
        
        let constraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: Constants.stackTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupTabBarView() {
        backgroundColor = R.Color.night
        layer.cornerRadius = Constants.tabBarViewCornerRadius
        customItemViews.forEach { $0.delegate = self }
    }
    
    func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        selectedItemIndex = index
    }
}

// MARK: - Interaction

extension TabBarView: TabItemViewProtocol {
    func didTapItem(with index: Int) {
        selectItem(index: index)
        delegate?.selectTabWith(index: index)
    }
}
