//
//  HomeStorePresenter.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 08.12.2022.
//

import UIKit

protocol HomeStorePresenterProtocol: AnyObject {
    func getLocation()
    func categoryItemCount() -> Int
    func categoryRequest(for indexPath: IndexPath) -> CategoryCellViewModelProtocol
    func didTapCategoryCell(at indexPath: IndexPath)
    func hotSalesItemCount() -> Int
    func hotSalesRequest(for indexPath: IndexPath) -> HomeStore?
    func bestSellerItemCount() -> Int
    func bestSellerRequest(for indexPath: IndexPath) -> BestSeller?
    func toggleFilterOptionsAppearance()
    func getBrands() -> [String]
    func getPrices() -> [String]
    func getSizes() -> [String]
}

final class HomeStorePresenter: HomeStorePresenterProtocol {
    
    // MARK: - Properties
    
    public unowned var view: HomeStoreVCProtocol!
    private var locationService: LocationServiceProtocol
    private var dataService: DataServiceProtocol
    private var networkService: NetworkServiceProtocol
    private var categories = [CategoryCellViewModelProtocol]()
    private var hotSales = [HomeStore]()
    private var bestSellers = [BestSeller]()
        
    // MARK: - Init
    
    init(
        view: HomeStoreVCProtocol,
        locationService: LocationServiceProtocol,
        dataService: DataServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.view = view
        self.locationService = locationService
        self.dataService = dataService
        self.networkService = networkService
        start()
    }
    
    // MARK: - Start
    
    func start() {
        fetchCategoryData()
        fetchHotSalesData()
        fetchBestSellerData()
        didTapCategoryCell(at: IndexPath(item: 0, section: 0))
    }
}

// MARK: - Location

extension HomeStorePresenter {
    func getLocation() {
        locationService.bindLocation { [weak self] location in
            self?.view.setLocation(with: location ?? R.Text.Home.locationTitle)
        }
    }
}

// MARK: - Category

extension HomeStorePresenter {
    func categoryItemCount() -> Int {
        return categories.count
    }
    
    func categoryRequest(for indexPath: IndexPath) -> CategoryCellViewModelProtocol {
        return categories[indexPath.row]
    }
    
    func didTapCategoryCell(at indexPath: IndexPath)  {
        categories.forEach { $0.isSelected = false }
        categories[indexPath.row].isSelected = true
        view.updateCategories()
    }
}

// MARK: - Hot Sales

extension HomeStorePresenter {
    func hotSalesItemCount() -> Int {
        return hotSales.count
    }
    
    func hotSalesRequest(for indexPath: IndexPath) -> HomeStore? {
        return hotSales[indexPath.row]
    }
}

// MARK: - Best Seller

extension HomeStorePresenter {
    func bestSellerItemCount() -> Int {
        return bestSellers.count
    }
    
    func bestSellerRequest(for indexPath: IndexPath) -> BestSeller? {
        return bestSellers[indexPath.row]
    }
}

// MARK: - Filter Options

extension HomeStorePresenter {
    func toggleFilterOptionsAppearance() {
        NotificationCenter.default.post(
            name: NSNotification.Name(R.Text.NotificationKey.tabBar),
            object: nil
        )
        
        view.toggleFilterViewAppearance()
    }
    
    func getBrands() -> [String] {
        dataService.getBrands()
    }
    
    func getPrices() -> [String] {
        dataService.getPrices()
    }
    
    func getSizes() -> [String] {
        dataService.getSizes()
    }
}

// MARK: - Data

private extension HomeStorePresenter {
    func fetchCategoryData() {
        categories = dataService.getCategories()
        view.updateCategories()
    }
    
    func fetchHotSalesData() {
        networkService.fetchData(
            with: R.Text.Url.homeStoreProducts,
            for: ProductModel.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.hotSales = products.homeStore
                self.view.updateHotSales()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchBestSellerData() {
        networkService.fetchData(
            with: R.Text.Url.homeStoreProducts,
            for: ProductModel.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.bestSellers = products.bestSeller
                self.view.updateBestSeller()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


