//
//  ProfileVC.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 04.12.2022.
//

import UIKit
import SafariServices

final class ProfileVC: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        button.tintColor = R.Color.peach
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupLayout()
    }
}

// MARK: - Setups

private extension ProfileVC {
    func setupVC() {
        view.backgroundColor = R.Color.background
        navigationItem.title = R.Text.Profile.profile
    }
    
    func setupLayout() {
        view.addSubview(button)
        button.prepareForAutoLayout()
        
        let constraints = [
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Actions

private extension ProfileVC {
    @objc func didTapProfile() {
        guard let url = URL(string: R.Text.Url.profile) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
