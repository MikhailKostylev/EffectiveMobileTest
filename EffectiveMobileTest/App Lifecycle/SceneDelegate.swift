//
//  SceneDelegate.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 02.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(scene: scene)
    }
}

// MARK: - Private

private extension SceneDelegate {
    func setupWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TabBarController()
        window?.backgroundColor = R.Color.background
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
}

