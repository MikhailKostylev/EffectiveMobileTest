//
//  ColorCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: ColorCollectionViewCell.self)
    
    public var color: String! {
        didSet {
            configureUI()
        }
    }
        
    // MARK: - Subviews
    
    private lazy var colorImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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

private extension ColorCollectionViewCell {
    func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = contentView.width / 2
        contentView.layer.masksToBounds = true
    }
    
    func addSubviews() {
        contentView.addSubview(colorImageView)
    }
    
    func configureUI() {
        contentView.backgroundColor = UIColor.init(hexString: color)
        colorImageView.image = isSelected ? R.Image.Home.check : nil
    }
}

// MARK: - Constants

private extension ColorCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let colorImageViewWidth: CGFloat = 17
        static let colorImageViewHeight: CGFloat = 13
    }
}

// MARK: - Layout

private extension ColorCollectionViewCell {
    func setupLayout() {
        colorImageView.prepareForAutoLayout()
        
        let constraints = [
            colorImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorImageView.widthAnchor.constraint(equalToConstant: C.colorImageViewWidth),
            colorImageView.heightAnchor.constraint(equalToConstant: C.colorImageViewHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
