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
    
    private lazy var bannerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
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
        contentView.backgroundColor = R.Color.imageBannerCellBackground
        contentView.layer.cornerRadius = C.imageBannerCellCornerRadius
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    }
    
    func addSubviews() {
        contentView.addSubview(bannerImageView)
    }
    
    func configureUI() {
        animateCell()
        ImageLoaderService.shared.loadImage(for: imageUrl) { [weak self] image in
            self?.bannerImageView.image = image
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
        static let animationDuration: CGFloat = 0.3
        static let cellMaxScale: CGFloat = 1
        static let cellMinScale: CGFloat = 0.9
    }
}

// MARK: - Layout

private extension ImageBannerCollectionViewCell {
    func setupLayout() {
        bannerImageView.prepareForAutoLayout()
        
        let constraints = [
            bannerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bannerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
