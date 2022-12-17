//
//  CharacteristicsView.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

final class CharacteristicsView: UIStackView {
        
    // MARK: - Subviews
    
    private let cpuStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.imageTitleSpacing
        return stackView
    }()
    
    private let cameraStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.imageTitleSpacing
        return stackView
    }()
    
    private let memoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.imageTitleSpacing
        return stackView
    }()
    
    private let storageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = C.imageTitleSpacing
        return stackView
    }()
    
    private let cpuImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Home.cpu
        view.tintColor = R.Color.grayIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Home.camera
        view.tintColor = R.Color.grayIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let memoryImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Home.memory
        view.tintColor = R.Color.grayIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let storageImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.Image.Home.storage
        view.tintColor = R.Color.grayIcon
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let cpuTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.grayText
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    private let cameraTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.grayText
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    private let memoryTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.grayText
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    private let storageTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = R.Color.grayText
        view.font = R.Font.markPro(type: .regular, size: C.titleFontSize)
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        addSubviews()
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

private extension CharacteristicsView {
    func setup() {
        backgroundColor = .white
        alignment = .fill
        distribution = .equalCentering
    }
    
    func addSubviews() {
        cpuStackView.addArrangedSubview(cpuImageView)
        cpuStackView.addArrangedSubview(cpuTitleLabel)
        cameraStackView.addArrangedSubview(cameraImageView)
        cameraStackView.addArrangedSubview(cameraTitleLabel)
        memoryStackView.addArrangedSubview(memoryImageView)
        memoryStackView.addArrangedSubview(memoryTitleLabel)
        storageStackView.addArrangedSubview(storageImageView)
        storageStackView.addArrangedSubview(storageTitleLabel)
        
        [
            cpuStackView,
            cameraStackView,
            memoryStackView,
            storageStackView
        ].forEach { addArrangedSubview($0) }
    }
    
    func setupSubviews() {
        
    }
}

// MARK: - Public

extension CharacteristicsView {
    public func setupSubviews(with viewModel: ProductDetailsModel) {
        cpuTitleLabel.text = viewModel.cpu
        cameraTitleLabel.text = viewModel.camera
        memoryTitleLabel.text = viewModel.ssd
        storageTitleLabel.text = viewModel.sd
    }
}

// MARK: - Constants

private extension CharacteristicsView {
    typealias C = Constants
    
    enum Constants {
        static let imageTitleSpacing: CGFloat = 9
        static let titleFontSize: CGFloat = 11
    }
}
