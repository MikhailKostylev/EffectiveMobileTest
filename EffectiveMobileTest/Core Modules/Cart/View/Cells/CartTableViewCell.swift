//
//  CartTableViewCell.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import UIKit

protocol CartTableViewCellProtocol: AnyObject {
    func didTapMinus(at cell: UITableViewCell)
    func didTapPlus(at cell: UITableViewCell)
    func didTapDelete(at cell: UITableViewCell)
}

final class CartTableViewCell: UITableViewCell {
    static let id = String(describing: CartTableViewCell.self)
    
    weak var delegate: CartTableViewCellProtocol?
    
    var viewModel: Basket! {
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
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = R.Color.cartCellBackground
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = C.imageCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .medium, size: C.labelFontSize)
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.peach
        view.textAlignment = .left
        view.font = R.Font.markPro(type: .medium, size: C.labelFontSize)
        return view
    }()
    
    private let stepperStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.backgroundColor = R.Color.cartCellBackground
        view.layer.cornerRadius = C.stepperStackCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let minusButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.minus, for: .normal)
        view.tintColor = .white
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.textColor = .white
        view.textAlignment = .center
        view.font = R.Font.markPro(type: .medium, size: C.labelFontSize)
        return view
    }()
    
    private let plusButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.plus, for: .normal)
        view.tintColor = .white
        return view
    }()
    
    private let deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.trash, for: .normal)
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addSubviews()
        setupLayout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CartTableViewCell {
    func setup() {
        contentView.backgroundColor = R.Color.night
        separatorInset = .zero
        selectionStyle = .none
    }
    
    func addSubviews() {
        [
            minusButton,
            countLabel,
            plusButton
        ].forEach { stepperStackView.addArrangedSubview($0) }
        
        [
            productImageView,
            spinner,
            titleLabel,
            priceLabel,
            stepperStackView,
            deleteButton
        ].forEach { contentView.addSubview($0) }
    }
    
    func configureUI() {
        ImageLoaderService.shared.loadImage(for: viewModel.images) { [weak self] image in
            self?.productImageView.image = image
            self?.spinner.stopAnimating()
        }
        
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price.convertToDollarsWithCents()?.replacingOccurrences(of: ",", with: "")
        countLabel.text = "\(viewModel.count ?? 1)"
    }
    
    func addActions() {
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension CartTableViewCell {
    @objc func didTapMinus() {
        delegate?.didTapMinus(at: self)
    }
    
    @objc func didTapPlus() {
        delegate?.didTapPlus(at: self)
    }
    
    @objc func didTapDelete() {
        delegate?.didTapDelete(at: self)
    }
}

// MARK: - Constants

private extension CartTableViewCell {
    typealias C = Constants
    
    enum Constants {
        static let imageCornerRadius: CGFloat = 10
        static let labelFontSize: CGFloat = 20
        static let stepperStackSpacing: CGFloat = 6
        
        static let productImageLeading: CGFloat = 33
        static let productImageSize: CGFloat = 88
        static let titleLabelLeading: CGFloat = 17
        static let titleLabelTrailing: CGFloat = -10
        static let priceLabelTop: CGFloat = 6
        static let deleteButtonTrailing: CGFloat = -32
        static let stepperStackTrailing: CGFloat = -17
        static let stepperStackWidth: CGFloat = 26
        static let stepperStackHeight: CGFloat = 68
        static var stepperStackCornerRadius: CGFloat {
            stepperStackWidth / 2
        }
    }
}

// MARK: - Layout

private extension CartTableViewCell {
    func setupLayout() {
        [
            productImageView,
            spinner,
            titleLabel,
            priceLabel,
            stepperStackView,
            deleteButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.productImageLeading),
            productImageView.widthAnchor.constraint(equalToConstant: C.productImageSize),
            productImageView.heightAnchor.constraint(equalToConstant: C.productImageSize),
            
            spinner.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: C.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: stepperStackView.leadingAnchor, constant: C.titleLabelTrailing),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.priceLabelTop),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            deleteButton.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: C.deleteButtonTrailing),
            
            stepperStackView.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            stepperStackView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: C.stepperStackTrailing),
            stepperStackView.widthAnchor.constraint(equalToConstant: C.stepperStackWidth),
            stepperStackView.heightAnchor.constraint(equalToConstant: C.stepperStackHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
