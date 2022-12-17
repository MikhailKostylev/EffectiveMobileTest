//
//  LocationFilterView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 10.12.2022.
//

import UIKit

protocol LocationFilterViewProtocol: AnyObject {
    func didTapLocation()
    func didTapFilter()
}

final class LocationFilterView: UIView {
    
    public weak var delegate: LocationFilterViewProtocol?
    
    // MARK: - Subviews
    
    private let geoPinButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.geoPin, for: .normal)
        return view
    }()
    
    private let titleButton: UIButton = {
        let view = UIButton()
        view.setTitle(R.Text.Home.locationTitle, for: .normal)
        view.titleLabel?.font = R.Font.markPro(type: .medium, size: C.titleFontSize)
        view.setTitleColor(R.Color.text, for: .normal)
        return view
    }()
    
    private let downArrowButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.downArrow, for: .normal)
        return view
    }()
    
    private let filterButton: UIButton = {
        let view = UIButton()
        view.setImage(R.Image.Home.filter, for: .normal)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupLayout()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Public

extension LocationFilterView {
    public func setLocation(with str: String) {
        titleButton.setTitle(str, for: .normal)
    }
}

// MARK: - Setups

private extension LocationFilterView {
    func setup() {
        backgroundColor = R.Color.background
    }
    
    func addSubviews() {
        addSubview(geoPinButton)
        addSubview(titleButton)
        addSubview(downArrowButton)
        addSubview(filterButton)
    }
    
    func addActions() {
        [
            geoPinButton,
            titleButton,
            downArrowButton
        ].forEach { $0.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside) }
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
    }
}

// MARK: - Action

private extension LocationFilterView {
    @objc func didTapLocation() {
        delegate?.didTapLocation()
    }
    
    @objc func didTapFilter() {
        delegate?.didTapFilter()
    }
}

// MARK: - Constants

private extension LocationFilterView {
    typealias C = Constants
    
    enum Constants {
        static let titleFontSize: CGFloat = 15
        
        static let geoPinTrailing: CGFloat = -11
        static let downArrowLeading: CGFloat = 8
        static let filterButtonTrailing: CGFloat = -35
    }
}

// MARK: - Layout

private extension LocationFilterView {
    func setupLayout() {
        [
            geoPinButton,
            titleButton,
            downArrowButton,
            filterButton
        ].forEach { $0.prepareForAutoLayout() }
        
        let constraints = [
            titleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            geoPinButton.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor),
            geoPinButton.trailingAnchor.constraint(equalTo: titleButton.leadingAnchor, constant: C.geoPinTrailing),
            
            downArrowButton.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor),
            downArrowButton.leadingAnchor.constraint(equalTo: titleButton.trailingAnchor, constant: C.downArrowLeading),
            
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: C.filterButtonTrailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
