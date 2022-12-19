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
    
    private let cartCounterLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = R.Color.peach
        view.font = R.Font.markPro(type: .bold, size: C.cartCounterFontSize)
        view.textColor = R.Color.night
        view.layer.cornerRadius = C.cartCounterCornerRadius
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.markPro(type: .bold, size: C.titleLabelSize)
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
    private var cartCounter: Int? {
        didSet {
            updateCartCounter()
        }
    }
    
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
        addObserver()
    }
    
    required init(coder: NSCoder) {
        self.item = nil
        self.index = 0
        super.init(coder: coder)
    }
    
    // MARK: - Increase Tap Area
    
    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let margin: CGFloat = C.tapableArea
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}

// MARK: - Setups

private extension TabItemView {
    func setupHierarchy() {
        addArrangedSubview(iconImageView)
        addArrangedSubview(titleLabel)
        iconImageView.addSubview(cartCounterLabel)
    }
    
    func setupTabItemView() {
        axis = .horizontal
        alignment = .center
        distribution = .fillProportionally
        spacing = C.iconLabelSpacing
    }
    
    func configureContent() {
        iconImageView.image = isSelected ? item?.selectedIcon : item?.icon
        titleLabel.text = isSelected ? item?.selectedName : nil
    }
    
    func updateCartCounter() {
        if index == 1 {
            cartCounterLabel.isHidden = (cartCounter == 0 || cartCounter == nil)
            if let counter = cartCounter {
                cartCounterLabel.text = String(counter)
            }
        }
    }
}

// MARK: - Observer

private extension TabItemView {
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setCartCounter(_:)),
            name: NSNotification.Name(R.Text.NotificationKey.tabBarCounter),
            object: nil
        )
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

// MARK: - Actions

private extension TabItemView {
    @objc func didTapItem() {
        delegate?.didTapItem(with: index)
    }
    
    @objc func setCartCounter(_ notification: NSNotification) {
        if let counter = notification.userInfo?[R.Text.NotificationKey.tabBarCounter] as? Int {
            cartCounter = counter
        }
    }
}

// MARK: - Animations

private extension TabItemView {
    func animateItems() {
        if isSelected {
            let timeInterval: TimeInterval = C.animationDuration
            let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: C.animationDamping) {
                self.transform = CGAffineTransform.identity.scaledBy(x: C.animationScale, y: C.animationScale)
            }
            propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(timeInterval))
            propertyAnimator.startAnimation()
        }
        
        UIView.transition(
            with: iconImageView,
            duration: C.animationDuration,
            options: .transitionCrossDissolve
        ) {
            self.configureContent()
        }
    }
}

// MARK: - Constants

private extension TabItemView {
    typealias C = Constants
    
    enum Constants {
        static let tapableArea: CGFloat = 20
        static let titleLabelSize: CGFloat = 15
        static let iconLabelSpacing: CGFloat = 7
        static let tabBarHeight: CGFloat = 72
        static let animationDuration: Double = 0.4
        static let animationDamping: Double = 0.9
        static let animationScale: Double = 0.5
        static let cartCounterFontSize: CGFloat = 14
        static let cartCounterSize: CGFloat = 20
        static let cartCounterX: CGFloat = 12
        static let cartCounterY: CGFloat = -12
        static var cartCounterCornerRadius: CGFloat {
            cartCounterSize / 2
        }
    }
}

// MARK: - Layout

private extension TabItemView {
    func setupLayout() {
        cartCounterLabel.prepareForAutoLayout()
        
        let constraints = [
            iconImageView.heightAnchor.constraint(equalToConstant: C.tabBarHeight),
            
            cartCounterLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor, constant: C.cartCounterX),
            cartCounterLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: C.cartCounterY),
            cartCounterLabel.widthAnchor.constraint(equalToConstant: C.cartCounterSize),
            cartCounterLabel.heightAnchor.constraint(equalToConstant: C.cartCounterSize)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
