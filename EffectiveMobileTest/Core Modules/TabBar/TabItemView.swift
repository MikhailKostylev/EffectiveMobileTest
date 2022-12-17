//
//  TabItemView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 05.12.2022.
//

import UIKit

protocol TabItemViewProtocol: AnyObject {
    func didTapItem(with index: Int)
}

final class TabItemView: UIStackView {
    
    // MARK: - Subviews
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.markPro(type: .bold, size: Constants.titleLabelSize)
        label.textColor = .white
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties
    
    public weak var delegate: TabItemViewProtocol?
    public let index: Int
    public var isSelected = false {
        didSet {
            titleLabel.isHidden = !isSelected
            animateItems()
        }
    }
    
    private let item: TabItemModel?
    
    // MARK: - Init
    
    init(with item: TabItemModel, index: Int) {
        self.item = item
        self.index = index
        super.init(frame: .zero)

        setupHierarchy()
        setupTabItemView()
        setupLayout()
        configureContent()
        addTapGesture()
    }
    
    required init(coder: NSCoder) {
        self.item = nil
        self.index = 0
        super.init(coder: coder)
    }
    
    // MARK: - Increase Tap Area
    
    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let margin: CGFloat = Constants.tapableArea
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}

// MARK: - Constants

private extension TabItemView {
    enum Constants {
        static let tapableArea: CGFloat = 20
        static let titleLabelSize: CGFloat = 15
        static let iconLabelSpacing: CGFloat = 7
        static let tabBarHeight: CGFloat = 72
        static let animationDuration: Double = 0.4
        static let animationDamping: Double = 0.9
        static let animationScale: Double = 0.5
    }
}

// MARK: - Setups

private extension TabItemView {
    func setupHierarchy() {
        addArrangedSubview(iconImageView)
        addArrangedSubview(titleLabel)
    }
    
    func setupTabItemView() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = Constants.iconLabelSpacing
    }
    
    func setupLayout() {
        let constraints = [
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureContent() {
        iconImageView.image = isSelected ? item?.selectedIcon : item?.icon
        titleLabel.text = isSelected ? item?.selectedName : nil
    }
}

// MARK: - Gestures

private extension TabItemView {
    func addTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapItem)
        )
        self.addGestureRecognizer(tap)
    }
}

// MARK: - Interaction

private extension TabItemView {
    @objc func didTapItem() {
        delegate?.didTapItem(with: index)
    }
}

// MARK: - Animations

private extension TabItemView {
    func animateItems() {
        if isSelected {
            let timeInterval: TimeInterval = Constants.animationDuration
            let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: Constants.animationDamping) {
                self.transform = CGAffineTransform.identity.scaledBy(x: Constants.animationScale, y: Constants.animationScale)
            }
            propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(timeInterval))
            propertyAnimator.startAnimation()
        }
        
        UIView.transition(
            with: iconImageView,
            duration: Constants.animationDuration,
            options: .transitionCrossDissolve
        ) {
            self.configureContent()
        }
    }
}

