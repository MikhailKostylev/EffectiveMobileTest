//
//  HotSalesCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 13.12.2022.
//

import UIKit

protocol HotSalesCellProtocol: AnyObject {
    func didTapBuy(at itemID: Int, isBuy: Bool)
}

final class HotSalesCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: HotSalesCollectionViewCell.self)
    
    weak var delegate: HotSalesCellProtocol?
    
    var viewModel: HomeStore! {
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
        view.backgroundColor = .white
        return view
    }()
    
    private let newLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.newLabel
        view.numberOfLines = 1
        view.textColor = .white
        view.textAlignment = .center
        view.font = R.Font.markPro(type: .bold, size: C.newFontSize)
        view.backgroundColor = R.Color.peach
        view.layer.cornerRadius = C.newLabelCornerRadius
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = .white
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .bold, size: C.titleLabelFontSize)
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .regular, size: C.subtitleLabelFontSize)
        return view
    }()
    
    private let buyButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setTitle(R.Text.Home.buyNow, for: .normal)
        view.setTitleColor(R.Color.night, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .bold, size: C.buyButtonFontSize)
        view.layer.cornerRadius = C.buyButtonCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        addAction()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension HotSalesCollectionViewCell {
    func setup() {
        contentView.backgroundColor = R.Color.background
        layer.cornerRadius = C.selfCornerRadius
        layer.masksToBounds = true
    }
    
    func addSubviews() {
        [
            bannerImageView,
            newLabel,
            titleLabel,
            subtitleLabel,
            buyButton,
            spinner,
        ].forEach { contentView.addSubview($0) }
    }
    
    func configureUI() {
        ImageLoaderService.shared.loadImage(for: viewModel.picture) { [weak self] image in
            self?.bannerImageView.image = image
            self?.spinner.stopAnimating()
        }
        
        newLabel.isHidden = viewModel.isNew ?? false
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    func addAction() {
        buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension HotSalesCollectionViewCell {
    @objc func didTapBuy() {
        viewModel.isBuy = !viewModel.isBuy
        delegate?.didTapBuy(at: viewModel.id, isBuy: viewModel.isBuy)
    }
}

// MARK: - Constants

private extension HotSalesCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let selfCornerRadius: CGFloat = 10
        static let newFontSize: CGFloat = 10
        static let newLabelTop: CGFloat = 14
        static let newLabelLeading: CGFloat = 25
        static let newLabelSize: CGFloat = 27
        static let titleLabelFontSize: CGFloat = 25
        static let subtitleLabelFontSize: CGFloat = 11
        static let buyButtonFontSize: CGFloat = 11
        static let buyButtonCornerRadius: CGFloat = 5
        static let titleLabelTop: CGFloat = 18
        static let subtitleLabelTop: CGFloat = 5
        static let buyButtonWidth: CGFloat = 98
        static let buyButtonHeight: CGFloat = 23
        static let buyButtonBottom: CGFloat = -26
        static var newLabelCornerRadius: CGFloat {
            newLabelSize / 2
        }
    }
}

// MARK: - Layout

private extension HotSalesCollectionViewCell {
    func setupLayout() {
        [
            spinner,
            bannerImageView,
            newLabel,
            titleLabel,
            subtitleLabel,
            buyButton
        ].forEach { $0.prepareForAutoLayout() }

        let constraints = [
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            newLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.newLabelTop),
            newLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.newLabelLeading),
            newLabel.widthAnchor.constraint(equalToConstant: C.newLabelSize),
            newLabel.heightAnchor.constraint(equalToConstant: C.newLabelSize),
            
            titleLabel.topAnchor.constraint(equalTo: newLabel.bottomAnchor, constant: C.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: newLabel.leadingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.subtitleLabelTop),
            subtitleLabel.leadingAnchor.constraint(equalTo: newLabel.leadingAnchor),
            
            buyButton.leadingAnchor.constraint(equalTo: newLabel.leadingAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: C.buyButtonWidth),
            buyButton.heightAnchor.constraint(equalToConstant: C.buyButtonHeight),
            buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: C.buyButtonBottom)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
