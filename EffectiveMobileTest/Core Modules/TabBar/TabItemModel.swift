//
//  TabItem.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 05.12.2022.
//

import UIKit

enum TabItemModel: CaseIterable {
    case home
    case basket
    case favorites
    case profile
}

extension TabItemModel {
    var icon: UIImage? {
        var icon: UIImage
        
        switch self {
        
        case .home:
            icon = R.Image.TabBar.explorer
        case .basket:
            icon = R.Image.TabBar.basket
        case .favorites:
            icon = R.Image.TabBar.favorite
        case .profile:
            icon = R.Image.TabBar.profile
        }
        
        return icon
    }
    
    var selectedIcon: UIImage? {
        return R.Image.TabBar.selected
    }
    
    var selectedName: String {
        var name: String
        
        switch self {
        
        case .home:
            name = R.Text.Home.explorer
        case .basket:
            name = R.Text.Basket.basket
        case .favorites:
            name = R.Text.Favorites.favorites
        case .profile:
            name = R.Text.Profile.profile
        }
        
        return name
    }
}
