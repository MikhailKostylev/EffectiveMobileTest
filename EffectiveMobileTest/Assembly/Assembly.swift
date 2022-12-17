//
//  Assembly.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 09.12.2022.
//

import UIKit

final class Assembly {

    // MARK: - Home
    
    static func configureHomeStoreModule() -> UIViewController {
        let view = HomeStoreVC()
        let locationService = LocationService()
        let dataService = DataService()
        let networkService = NetworkService()
        
        let presenter = HomeStorePresenter(
            view: view,
            locationService: locationService,
            dataService: dataService,
            networkService: networkService
        )

        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
    
    static func configureProductDetailsModule(itemID: Int) -> UIViewController {
        let view = ProductDetailsVC()
        let dataService = DataService()
        let networkService = NetworkService()
        
        let presenter = ProductDetailsPresenter(
            view: view,
            itemID: itemID,
            dataService: dataService,
            networkService: networkService
        )

        view.presenter = presenter
        return view
    }
    
    // MARK: - Basket
    
    static func configureBasketModule() -> UIViewController {
        let view = BasketVC()
        return view
    }
    
    // MARK: - Favorites
    
    static func configureFavoritesModule() -> UIViewController {
        let view = FavoritesVC()
        return view
    }
    
    // MARK: - Profile
    
    static func configureProfileModule() -> UIViewController {
        let view = ProfileVC()
        return view
    }
}
