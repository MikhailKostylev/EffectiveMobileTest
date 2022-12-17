//
//  BestSellerCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 13.12.2022.
//

import UIKit

protocol BestSellerCellProtocol: AnyObject {
    func toggleFavorite(at itemID: Int, isFavorite: Bool)
    func didTapItem(at itemID: Int)
}

final class BestSellerCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: BestSellerCollectionViewCell.self)
    
    weak var delegate: BestSellerCellProtocol?
    
    var viewModel: BestSeller! {
        didSet {
            configureUI()
        }
    }
        
    // MARK: - Subviews
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.tintColor = .black
        view.startAnimating()
        return view
    }()
    
    private let bannerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.layer.cornerRadius = C.bannerCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.heart, for: .normal)
        view.tintColor = R.Color.peach
        view.backgroundColor = .white
        view.layer.cornerRadius = C.favoriteButtonCornerRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = R.Color.favoriteShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = C.favoriteShadowRadius
        view.layer.masksToBounds = false
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.night
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .bold, size: C.priceLabelFontSize)
        return view
    }()
    
    private let discountPriceLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.discountPrice
        view.textAlignment = .center
        view.font = R.Font.markPro(type: .medium, size: C.discountPriceFontSize)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.night
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .regular, size: C.titleLabelFontSize)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        addActions()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension BestSellerCollectionViewCell {
    func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = C.selfCornerRadius
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = R.Color.bestSellerShadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = C.selfShadowRadius
        layer.masksToBounds = false
    }
    
    func addSubviews() {
        [
            bannerImageView,
            favoriteButton,
            priceLabel,
            discountPriceLabel,
            titleLabel,
            spinner
        ].forEach { contentView.addSubview($0) }
    }
    
    func configureUI() {
        ImageLoaderService.shared.loadImage(for: viewModel.picture) { [weak self] image in
            self?.bannerImageView.image = image
            self?.spinner.stopAnimating()
        }
        
        favoriteButton.setImage(viewModel.isFavorites ? R.Image.Home.heartFill : R.Image.Home.heart, for: .normal)
        titleLabel.text = viewModel.title
        discountPriceLabel.attributedText = viewModel.discountPrice.convertToDollars()?.strikeThrough()
        priceLabel.text = viewModel.priceWithoutDiscount.convertToDollars()
    }
    
    func addActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        contentView.addGestureRecognizer(tap)
    }
}

// MARK: - Actions

private extension BestSellerCollectionViewCell {
    @objc func didTapFavorite() {
        viewModel.isFavorites = !viewModel.isFavorites
        delegate?.toggleFavorite(at: viewModel.id, isFavorite: viewModel.isFavorites)
    }
    
    @objc func didTapCell() {
        delegate?.didTapItem(at: viewModel.id)
    }
}

// MARK: - Constants

private extension BestSellerCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let selfCornerRadius: CGFloat = 10
        static let selfShadowRadius: CGFloat = 10
        static let bannerCornerRadius: CGFloat = 10
        static let favoriteButtonTop: CGFloat = 11
        static let favoriteButtonTrailing: CGFloat = -13
        static let favoriteButtonSize: CGFloat = 25
        static let favoriteShadowRadius: CGFloat = 20
        static let priceLabelFontSize: CGFloat = 16
        static let priceLabelBottom: CGFloat = -5
        static let discountPriceFontSize: CGFloat = 10
        static let titleLabelFontSize: CGFloat = 10
        static let titleLabelLeading: CGFloat = 20
        static let titleLabelBottom: CGFloat = -15
        static var favoriteButtonCornerRadius: CGFloat {
            favoriteButtonSize / 2
        }
    }
}

// MARK: - Layout

private extension BestSellerCollectionViewCell {
    func setupLayout() {
        [
            spinner,
            bannerImageView,
            favoriteButton,
            priceLabel,
            discountPriceLabel,
            titleLabel
        ].forEach { $0.prepareForAutoLayout() }

        let constraints = [
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.favoriteButtonTop),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: C.favoriteButtonTrailing),
            favoriteButton.widthAnchor.constraint(equalToConstant: C.favoriteButtonSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: C.favoriteButtonSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.titleLabelLeading),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: C.titleLabelBottom),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: C.priceLabelBottom),
            
            discountPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 7),
            discountPriceLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
