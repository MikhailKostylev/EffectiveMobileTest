//
//  FilterOptionsView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 12.12.2022.
//

import UIKit

protocol FilterOptionsViewProtocol: AnyObject {
    func didTapClose()
    func didTapDone()
    func itemsRequest(for pickerType: PickerViewType) -> [String]
}

final class FilterOptionsView: UIView {
    
    public weak var delegate: FilterOptionsViewProtocol?
    
    private var currentPickerType: PickerViewType
    private var selectedItem: String? {
        didSet {
            switch currentPickerType {
                
            case .brand:
                brandButton.setLabel(with: selectedItem)
            case .price:
                priceButton.setLabel(with: selectedItem)
            case .size:
                sizeButton.setLabel(with: selectedItem)
            }
        }
    }
    
    // MARK: - Subviews
    
    private let closeButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = R.Color.night
        view.setImage(R.Image.Home.close, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = C.closeButtonRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.filterOptions
        view.textColor = R.Color.text
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    private let doneButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = R.Color.peach
        view.setTitle(R.Text.Home.done, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .medium, size: C.doneFontSize)
        view.layer.cornerRadius = C.doneButtonRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let brandLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.brand
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.textColor = R.Color.text
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.price
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.textColor = R.Color.text
        return view
    }()
    
    private let sizeLabel: UILabel = {
        let view = UILabel()
        view.text = R.Text.Home.size
        view.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.textColor = R.Color.text
        return view
    }()
    
    private let brandButton = SelectFilterButton()
    private let priceButton = SelectFilterButton()
    private let sizeButton = SelectFilterButton()

    private lazy var pickerViewPresenter: PickerViewPresenter = {
        let view = PickerViewPresenter()
        view.pickerDelegate = self
        view.didSelectItem = { [weak self] item in
            self?.selectedItem = item
        }
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        currentPickerType = .brand
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupLayout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        currentPickerType = .brand
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension FilterOptionsView {
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
            closeButton,
            titleLabel,
            doneButton
        ].forEach { addSubview($0) }
        
        [
            brandLabel,
            brandButton,
            priceLabel,
            priceButton,
            sizeLabel,
            sizeButton
        ].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
        addSubview(pickerViewPresenter)
    }
    
    func getPicketItems(for type: PickerViewType) {
        currentPickerType = type
        pickerViewPresenter.getItems()
        pickerViewPresenter.showPicker()
    }
    
    func addActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        brandButton.addTarget(self, action: #selector(didTapBrand), for: .touchUpInside)
        priceButton.addTarget(self, action: #selector(didTapPrice), for: .touchUpInside)
        sizeButton.addTarget(self, action: #selector(didTapSize), for: .touchUpInside)
    }
}

// MARK: - Public

extension FilterOptionsView {
    public func getFilterData() {
        PickerViewType.allCases.forEach {
            currentPickerType = $0
            pickerViewPresenter.getItems()
        }
    }
}

// MARK: - Action

private extension FilterOptionsView {
    @objc func didTapClose() {
        delegate?.didTapClose()
    }
    
    @objc func didTapDone() {
        delegate?.didTapDone()
    }
    
    @objc func didTapBrand() {
        getPicketItems(for: .brand)
    }
    
    @objc func didTapPrice() {
        getPicketItems(for: .price)
    }
    
    @objc func didTapSize() {
        getPicketItems(for: .size)
    }
}

// MARK: - PickerView Delegate

extension FilterOptionsView: PickerViewPresenterProtocol {
    func itemsRequest() -> [String] {
        guard let items = delegate?.itemsRequest(for: currentPickerType) else { return [] }
        return items
    }
}

// MARK: - Constants

private extension FilterOptionsView {
    typealias C = Constants
    
    enum Constants {
        static let selfShadowRadius: CGFloat = 20
        static let heightShadowOffset: CGFloat = -5
        static let titleFontSize: CGFloat = 18
        static let doneFontSize: CGFloat = 18
        static let closeButtonRadius: CGFloat = 10
        static let doneButtonRadius: CGFloat = 10
        static let selfCornerRadius: CGFloat = 30
        
        static let stackItemsSpacing: CGFloat = 18
        static let selectButtonCornerRadius: CGFloat = 5
        
        static let closeButtonTop: CGFloat = 24
        static let closeButtonLeading: CGFloat = 44
        static let closeButtonSize: CGFloat = 37
        
        static let doneButtonTop: CGFloat = 24
        static let doneButtonTrailing: CGFloat = -20
        static let doneButtonWidth: CGFloat = 86
        static let doneButtonHeight: CGFloat = 37
        
        static let stackViewTop: CGFloat = 34
        static let stackViewLeading: CGFloat = 46
        static let stackViewTrailing: CGFloat = -31
        static let stackViewBottom: CGFloat = -44
    }
}

// MARK: - Layout

private extension FilterOptionsView {
    func setupLayout() {
        [
            closeButton,
            titleLabel,
            doneButton,
            stackView
            
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: C.closeButtonTop),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.closeButtonLeading),
            closeButton.widthAnchor.constraint(equalToConstant: C.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: C.closeButtonSize),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            doneButton.topAnchor.constraint(equalTo: topAnchor, constant: C.doneButtonTop),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.doneButtonTrailing),
            doneButton.widthAnchor.constraint(equalToConstant: C.doneButtonWidth),
            doneButton.heightAnchor.constraint(equalToConstant: C.doneButtonHeight),
            
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: C.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: C.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: C.stackViewBottom)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
