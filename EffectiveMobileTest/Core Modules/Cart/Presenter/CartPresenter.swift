//
//  CartPresenter.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import Foundation

protocol CartPresenterProtocol {
    func fetchData()
    func toggleTabBarAppearance()
    func didTapMinus(at indexPath: IndexPath)
    func didTapPlus(at indexPath: IndexPath)
    func didTapDelete(at indexPath: IndexPath)
}

final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - Properties
    
    public unowned var view: CartVCProtocol!
    private var networkService: NetworkServiceProtocol
    private var product: CartModel!
        
    // MARK: - Init
    
    init(
        view: CartVCProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.view = view
        self.networkService = networkService
        start()
    }
    
    // MARK: - Start
    
    func start() {
        fetchData()
    }
}

// MARK: - Operations

extension CartPresenter {
    func didTapMinus(at indexPath: IndexPath) {
        var currentCount = product.basket[indexPath.row].count ?? 0
        if currentCount > 1 {
            currentCount -= 1
            product.basket[indexPath.row].count = currentCount
            view.changeProductCount(at: indexPath, with: currentCount)
            view.setTotalResult(with: calculateTotalPrice())
            setTabBarCounterIcon()
        }
    }
    
    func didTapPlus(at indexPath: IndexPath) {
        var currentCount = product.basket[indexPath.row].count ?? 0
        if currentCount < 100 {
            currentCount += 1
            product.basket[indexPath.row].count = currentCount
            view.changeProductCount(at: indexPath, with: currentCount)
            view.setTotalResult(with: calculateTotalPrice())
            setTabBarCounterIcon()
        }
    }
    
    func didTapDelete(at indexPath: IndexPath) {
        product.basket.remove(at: indexPath.row)
        view.receiveData(for: product)
        view.setTotalResult(with: calculateTotalPrice())
        setTabBarCounterIcon()
    }
}

// MARK: - Tab Bar

extension CartPresenter {
    func toggleTabBarAppearance() {
        NotificationCenter.default.post(
            name: NSNotification.Name(R.Text.NotificationKey.tabBarAppearance),
            object: nil
        )
    }
}

// MARK: - Data

extension CartPresenter {
    func fetchData() {
        networkService.fetchData(
            with: R.Text.Url.cart,
            for: CartModel.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.product = data
                self.updateView(with: data)
                self.setTabBarCounterIcon()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Private

private extension CartPresenter {
    func updateView(with data: CartModel) {
        let price = calculateTotalPrice()
        view.receiveData(for: data)
        view.setTotalResult(with: price)
        view.setDeliveryResult(with: data.delivery)
    }
    
    func calculateTotalPrice() -> Int {
        return product.basket.reduce(0) { partialResult, basket in
            partialResult + basket.price * (basket.count ?? 1)
        }
    }
    
    func setTabBarCounterIcon() {
        let cartCounter = product.basket.count
        let cartCounterDict = [R.Text.NotificationKey.tabBarCounter: cartCounter]
        
        NotificationCenter.default.post(
            name: NSNotification.Name(R.Text.NotificationKey.tabBarCounter),
            object: nil,
            userInfo: cartCounterDict
        )
    }
}
