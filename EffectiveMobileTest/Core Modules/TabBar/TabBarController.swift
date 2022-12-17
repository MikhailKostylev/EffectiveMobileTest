//
//  TabBarController.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 16.12.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Subviews
    
    private var tabBarView = TabBarView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        addObserver()
    }
}

// MARK: - Setup

private extension TabBarController {
    func setup() {
        tabBarView.delegate = self
        
        let controllers = [
            Assembly.configureHomeStoreModule(),
            Assembly.configureBasketModule(),
            Assembly.configureFavoritesModule(),
            Assembly.configureProfileModule()
        ]
        
        selectedIndex = 0
        tabBar.isHidden = true
        setViewControllers(controllers, animated: true)
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTabBarAppearance),
            name: NSNotification.Name(R.Text.NotificationKey.tabBar),
            object: nil
        )
    }
}

// MARK: - Action

extension TabBarController {
    @objc func toggleTabBarAppearance() {
        tabBarView.isHidden = !tabBarView.isHidden
    }
}

// MARK: - TabBar View Delegate

extension TabBarController: TabBarViewProtocol {
    func selectTabWith(index: Int) {
        selectedIndex = index
    }
}

// MARK: - Constants

private extension TabBarController {
    enum Constants {
        static let tabBarViewHeight: CGFloat = 72
    }
}

// MARK: - Layout

private extension TabBarController {
    func setupLayout() {
        view.addSubview(tabBarView)
        tabBarView.prepareForAutoLayout()
        
        let constraints = [
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: Constants.tabBarViewHeight),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
