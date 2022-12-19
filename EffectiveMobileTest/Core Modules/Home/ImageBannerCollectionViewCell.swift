//
//  ImageBannerCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 17.12.2022.
//

import UIKit

final class ImageBannerCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: ImageBannerCollectionViewCell.self)
    
    public var imageUrl: String! {
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
    
    private lazy var bannerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = C.imageBannerCellCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension ImageBannerCollectionViewCell {
    func setup() {
        contentView.layer.shadowOffset = CGSize(width: .zero, height: C.shadowOffsetHeight)
        contentView.layer.shadowColor = R.Color.imageBannerCellShadowRadius.cgColor
        contentView.layer.shadowRadius = C.imageBannerCellShadowRadius
        contentView.layer.shadowOpacity = 1
    }
    
    func addSubviews() {
        contentView.addSubview(bannerImageView)
        contentView.addSubview(spinner)
    }
    
    func configureUI() {
        animateCell()
        ImageLoaderService.shared.loadImage(for: imageUrl) { [weak self] image in
            self?.bannerImageView.image = image
            self?.spinner.stopAnimating()
        }
    }
}

// MARK: - Animation

private extension ImageBannerCollectionViewCell {
    func animateCell() {
        if !isSelected {
            UIView.animate(withDuration: C.animationDuration) {
                self.transform = CGAffineTransform(scaleX: C.cellMinScale, y: C.cellMinScale)
            }
        } else {
            UIView.animate(withDuration: C.animationDuration) {
                self.transform = CGAffineTransform(scaleX: C.cellMaxScale, y: C.cellMaxScale)
            }
        }
    }
}

// MARK: - Constants

private extension ImageBannerCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let imageBannerCellCornerRadius: CGFloat = 20
        static let imageBannerCellShadowRadius: CGFloat = 20
        static let shadowOffsetHeight: CGFloat = 10
        static let animationDuration: CGFloat = 0.3
        static let cellMaxScale: CGFloat = 1
        static let cellMinScale: CGFloat = 0.9
    }
}

// MARK: - Layout

private extension ImageBannerCollectionViewCell {
    func setupLayout() {
        spinner.prepareForAutoLayout()
        bannerImageView.prepareForAutoLayout()
        
        let constraints = [
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bannerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
