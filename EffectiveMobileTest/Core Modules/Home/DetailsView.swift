//
//  DetailsView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import Foundation

import UIKit

protocol DetailsViewProtocol: AnyObject {
    func didTapFavorite()
    func colorRequest(for indexPath: IndexPath) -> String
    func getColorCount() -> Int
    func capacityRequest(for indexPath: IndexPath) -> String
    func getCapacityCount() -> Int
}

final class DetailsView: UIView {
    
    public weak var delegate: DetailsViewProtocol?
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.textAlignment = .left
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.like, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = R.Color.night
        view.tintColor = .white
        view.layer.cornerRadius = C.buttonCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let starsStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = C.starsSpacing
        return view
    }()
    
    private let tabButtonsView = TabButtonsView()
    
    private let characteristicsView = CharacteristicsView()
    
    private let selectionTitleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.selection
        view.textColor = R.Color.night
        view.font = R.Font.markPro(type: .medium, size: C.selectionTitleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    private let colorCollectionView = ColorCollectionView()
    
    private let capacityCollectionView = CapacityCollectionView()
    
    private let addToCartButton = AddToCartButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
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

private extension DetailsView {
    func setup() {
        backgroundColor = .white
        layer.cornerRadius = C.selfCornerRadius
        layer.shadowOffset = CGSize(width: .zero, height: C.heightShadowOffset)
        layer.shadowColor = R.Color.filtersViewShadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = C.selfShadowRadius
        layer.masksToBounds = false
    }
    
    func addSubviews() {
        [
            titleLabel,
            favoriteButton,
            starsStackView,
            tabButtonsView,
            characteristicsView,
            selectionTitleLabel,
            colorCollectionView,
            capacityCollectionView,
            addToCartButton
        ].forEach { addSubview($0) }
    }
    
    func setupSubviews() {
        colorCollectionView.delegate = self
        capacityCollectionView.delegate = self
    }
    
    func addActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        addToCartButton.addTarget(self, action: #selector(didTapAddToCart), for: .touchUpInside)
    }
}

// MARK: - Public

extension DetailsView {
    public func setupSubviews(with viewModel: ProductDetailsModel) {
        titleLabel.text = viewModel.title
        favoriteButton.setImage(viewModel.isFavorites ? R.Image.Home.likeFill : R.Image.Home.like, for: .normal)
        characteristicsView.setupSubviews(with: viewModel)
        addToCartButton.setPriceLabel(with: viewModel.price.convertToDollarsWithCents())
        colorCollectionView.reloadData()
        capacityCollectionView.reloadData()
        starsStackView.subviews.forEach { $0.removeFromSuperview() }
        
        let starsCount = Int(viewModel.rating.rounded(.toNearestOrEven))
        (1...starsCount).forEach { _ in
            starsStackView.addArrangedSubview(UIImageView(image: R.Image.Home.star))
        }
    }
}

// MARK: - Action

private extension DetailsView {
    @objc func didTapFavorite() {
        delegate?.didTapFavorite()
    }
    
    @objc func didTapAddToCart() {
        print(#function)
    }
}

// MARK: - Color Collection Delegate

extension DetailsView: ColorCollectionViewProtocol {
    func colorRequest(for indexPath: IndexPath) -> String {
        delegate?.colorRequest(for: indexPath) ?? ""
    }
    
    func getColorCount() -> Int {
        delegate?.getColorCount() ?? 0
    }
}

// MARK: - Capacity Collection Delegate

extension DetailsView: CapacityCollectionViewProtocol {
    func capacityRequest(for indexPath: IndexPath) -> String {
        delegate?.capacityRequest(for: indexPath) ?? ""
    }
    
    func getCapacityCount() -> Int {
        delegate?.getCapacityCount() ?? 0
    }
}

// MARK: - Constants

private extension DetailsView {
    typealias C = Constants
    
    enum Constants {
        static let selfCornerRadius: CGFloat = 30
        static let selfShadowRadius: CGFloat = 20
        static let heightShadowOffset: CGFloat = -5
        static let titleFontSize: CGFloat = 24
        static let buttonCornerRadius: CGFloat = 10
        static let selectionTitleFontSize: CGFloat = 16
        
        static let titleLabelTop: CGFloat = 28
        static let titleLabelLeading: CGFloat = 38
        static let favoriteButtonTop: CGFloat = 28
        static let favoriteButtonTrailing: CGFloat = -37
        static let favoriteButtonWidth: CGFloat = 37
        static let favoriteButtonHeight: CGFloat = 33
        static let starsSpacing: CGFloat = 9
        static let starsStackViewTop: CGFloat = 7
        static let starsStackViewHeight: CGFloat = 18
        static let tabButtonsViewTop: CGFloat = 32
        static let tabButtonsViewLeading: CGFloat = 45
        static let tabButtonsViewTrailing: CGFloat = -40
        static let tabButtonsViewHeight: CGFloat = 33
        static let characteristicsViewTop: CGFloat = 35
        static let characteristicsViewHeight: CGFloat = 50
        static let selectionLabelTop: CGFloat = 29
        static let selectionLabelLeading: CGFloat = 30
        static let colorCollectionViewTop: CGFloat = 15
        static let colorCollectionViewWidth: CGFloat = 156
        static let colorCollectionViewHeight: CGFloat = 40
        static let capacityCollectionViewHeight: CGFloat = 30
        static let addToCartButtonLeading: CGFloat = 30
        static let addToCartButtonTrailing: CGFloat = -30
        static let addToCartButtonHeight: CGFloat = 54
        static let addToCartButtonBottom: CGFloat = -36
    }
}

// MARK: - Layout

private extension DetailsView {
    func setupLayout() {
        [
            titleLabel,
            favoriteButton,
            starsStackView,
            tabButtonsView,
            characteristicsView,
            selectionTitleLabel,
            colorCollectionView,
            capacityCollectionView,
            addToCartButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: C.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.titleLabelLeading),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: C.favoriteButtonTop),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.favoriteButtonTrailing),
            favoriteButton.widthAnchor.constraint(equalToConstant: C.favoriteButtonWidth),
            favoriteButton.heightAnchor.constraint(equalToConstant: C.favoriteButtonHeight),
  
            starsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.starsStackViewTop),
            starsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starsStackView.heightAnchor.constraint(equalToConstant: C.starsStackViewHeight),
            
            tabButtonsView.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: C.tabButtonsViewTop),
            tabButtonsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.tabButtonsViewLeading),
            tabButtonsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.tabButtonsViewTrailing),
            tabButtonsView.heightAnchor.constraint(equalToConstant: C.tabButtonsViewHeight),
            
            characteristicsView.topAnchor.constraint(equalTo: tabButtonsView.bottomAnchor, constant: C.characteristicsViewTop),
            characteristicsView.leadingAnchor.constraint(equalTo: tabButtonsView.leadingAnchor),
            characteristicsView.trailingAnchor.constraint(equalTo: tabButtonsView.trailingAnchor),
            characteristicsView.heightAnchor.constraint(equalToConstant: C.characteristicsViewHeight),
            
            selectionTitleLabel.topAnchor.constraint(equalTo: characteristicsView.bottomAnchor, constant: C.selectionLabelTop),
            selectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.selectionLabelLeading),
            
            colorCollectionView.topAnchor.constraint(equalTo: selectionTitleLabel.bottomAnchor, constant: C.colorCollectionViewTop),
            colorCollectionView.leadingAnchor.constraint(equalTo: selectionTitleLabel.leadingAnchor),
            colorCollectionView.widthAnchor.constraint(equalToConstant: C.colorCollectionViewWidth),
            colorCollectionView.heightAnchor.constraint(equalToConstant: C.colorCollectionViewHeight),
            
            capacityCollectionView.centerYAnchor.constraint(equalTo: colorCollectionView.centerYAnchor),
            capacityCollectionView.leadingAnchor.constraint(equalTo: colorCollectionView.trailingAnchor),
            capacityCollectionView.trailingAnchor.constraint(equalTo: addToCartButton.trailingAnchor),
            capacityCollectionView.heightAnchor.constraint(equalToConstant: C.capacityCollectionViewHeight),
            
            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.addToCartButtonLeading),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.addToCartButtonTrailing),
            addToCartButton.heightAnchor.constraint(equalToConstant: C.addToCartButtonHeight),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: C.addToCartButtonBottom)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
