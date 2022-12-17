//
//  CategoryCollectionViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 11.12.2022.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: CategoryCollectionViewCell.self)
    
    public var viewModel: CategoryCellViewModelProtocol! {
        didSet {
            configureUI()
        }
    }
        
    // MARK: - Subviews
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = contentView.width / 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = R.Color.categoryShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = C.shadowRadius
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = R.Color.grayIcon
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = R.Font.markPro(type: .medium, size: C.titleLabelSize)
        label.tintColor = R.Color.text
        return label
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

private extension CategoryCollectionViewCell {
    func setup() {
        contentView.backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        [
            circleView,
            iconImageView,
            titleLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    func configureUI() {
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.name
        circleView.backgroundColor = viewModel.isSelected ? R.Color.peach : .white
        iconImageView.tintColor = viewModel.isSelected ? .white : R.Color.grayIcon
        titleLabel.textColor = viewModel.isSelected ? R.Color.peach : R.Color.text
    }
}

// MARK: - Constants

private extension CategoryCollectionViewCell {
    typealias C = Constants
    
    enum Constants {
        static let shadowRadius: CGFloat = 20
        static let titleLabelSize: CGFloat = 12
        static let circleViewTop: CGFloat = 20
        static let titleLabelTop: CGFloat = 7
    }
}

// MARK: - Layout

private extension CategoryCollectionViewCell {
    func setupLayout() {
        [
            circleView,
            iconImageView,
            titleLabel
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: C.circleViewTop),
            circleView.widthAnchor.constraint(equalTo: widthAnchor),
            circleView.heightAnchor.constraint(equalTo: widthAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: C.titleLabelTop),
            titleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
