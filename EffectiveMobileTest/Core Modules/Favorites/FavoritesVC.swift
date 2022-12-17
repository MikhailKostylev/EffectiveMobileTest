//
//  FavoritesVC.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 04.12.2022.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    // MARK: - Subviews
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = R.Text.Favorites.empty
        label.textColor = .systemGray
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupLayout()
    }
}

// MARK: - Setups

private extension FavoritesVC {
    func setupVC() {
        view.backgroundColor = R.Color.background
        navigationItem.title = R.Text.Favorites.favorites
        view.addSubview(emptyLabel)
    }
    
    func setupLayout() {
        view.addSubview(emptyLabel)
        emptyLabel.prepareForAutoLayout()
        
        let constraints = [
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
