//
//  SearchView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 11.12.2022.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didTapQRButton()
    func didTypeSearchField(with text: String)
}

final class SearchView: UIView {
    
    public weak var delegate: SearchViewDelegate?
    
    // MARK: - Subviews
    
    private let searchTextField: UITextField = {
        let view = UITextField()
        view.clearButtonMode = .whileEditing
        view.autocorrectionType = .no
        view.returnKeyType = .done
        view.keyboardType = .default
        view.autocapitalizationType = .none
        view.backgroundColor = .white
        view.attributedPlaceholder = NSAttributedString(
            string: R.Text.Home.searchPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor : R.Color.placeholder,
                NSAttributedString.Key.font : R.Font.markPro(type: .light, size: C.placeholderFontSize)
            ]
        )
    
        let leftView = UIView(
            frame: CGRect(
                origin: .zero, size: CGSize(
                    width: C.leftViewFieldWidth,
                    height: C.searchFieldHeight
                )
            )
        )
        
        let iconView = UIImageView(
            frame: CGRect(
                x: C.iconViewX,
                y: C.iconViewY,
                width: C.iconViewSize,
                height: C.iconViewSize
            )
        )
        iconView.image = R.Image.Home.magnifier
        leftView.addSubview(iconView)
        view.leftViewMode = .always
        view.leftView = leftView
        view.layer.cornerRadius = C.textFieldCornerRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = R.Color.searchFieldShadow.cgColor
        view.layer.shadowRadius = C.shadowRadius
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        return view
    }()
    
    private let qrCodeButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = R.Color.peach
        view.setImage(R.Image.Home.qr, for: .normal)
        view.layer.cornerRadius = C.qrCodeButtonCornerRadius
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        setupSubviews()
        addActions()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension SearchView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(searchTextField)
        addSubview(qrCodeButton)
    }
    
    func setupSubviews() {
        searchTextField.delegate = self
    }
    
    func addActions() {
        qrCodeButton.addTarget(self, action: #selector(didTapQRButton), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension SearchView {
    @objc func didTapQRButton() {
        delegate?.didTapQRButton()
    }
    
    func didEndTyping() {
        searchTextField.resignFirstResponder()
        guard let text = searchTextField.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        delegate?.didTypeSearchField(with: text)
        searchTextField.text = nil
    }
}

// MARK: - TextField Delegate

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didEndTyping()
        return true
    }
}

// MARK: - Constants

private extension SearchView {
    typealias C = Constants
    
    enum Constants {
        static let placeholderAlpha: CGFloat = 0.5
        static let placeholderFontSize: CGFloat = 12
        static let textFieldCornerRadius: CGFloat = 17
        static let searchFieldHeight: CGFloat = 34
        static let leftViewFieldWidth: CGFloat = 56
        static let iconViewX: CGFloat = 24
        static let iconViewY: CGFloat = 9
        static let iconViewSize: CGFloat = 16
        static let shadowRadius: CGFloat = 20
        static let searchFieldTop: CGFloat = 20
        static let searchFieldLeading: CGFloat = 32
        static let searchFieldTrailing: CGFloat = -11
        static let qrCodeButtonTrailing: CGFloat = -37
        static var qrCodeButtonCornerRadius: CGFloat {
            searchFieldHeight / 2
        }
    }
}

// MARK: - Layout

private extension SearchView {
    func setupLayout() {
        [
            searchTextField,
            qrCodeButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            searchTextField.topAnchor.constraint(equalTo: topAnchor, constant: C.searchFieldTop),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.searchFieldLeading),
            searchTextField.trailingAnchor.constraint(equalTo: qrCodeButton.leadingAnchor, constant: C.searchFieldTrailing),
            searchTextField.heightAnchor.constraint(equalToConstant: C.searchFieldHeight),
            
            qrCodeButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            qrCodeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.qrCodeButtonTrailing),
            qrCodeButton.widthAnchor.constraint(equalTo: searchTextField.heightAnchor),
            qrCodeButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
