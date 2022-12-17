//
//  ProductDetailsPresenter.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 15.12.2022.
//

import Foundation

protocol ProductDetailsPresenterProtocol: AnyObject {
    func toggleTabBarAppearance()
    func colorRequest(for indexPath: IndexPath) -> String
    func getColorCount() -> Int
    func capacityRequest(for indexPath: IndexPath) -> String
    func getCapacityCount() -> Int
    func imageBannerRequest(for indexPath: IndexPath) -> String
    func getImageBannerCount() -> Int
}

final class ProductDetailsPresenter: ProductDetailsPresenterProtocol {
    
    // MARK: - Properties
    
    public unowned var view: ProductDetailsVCProtocol!
    private var itemID: Int
    private var dataService: DataServiceProtocol
    private var networkService: NetworkServiceProtocol
    private var viewModel: ProductDetailsModel?
    private var images = [String]()
    private var colors = [String]()
    private var capacity = [String]()
        
    // MARK: - Init
    
    init(
        view: ProductDetailsVCProtocol,
        itemID: Int,
        dataService: DataServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.view = view
        self.itemID = itemID
        self.dataService = dataService
        self.networkService = networkService
        start()
    }
    
    // MARK: - Start
    
    func start() {
        fetchData()
    }
}

// MARK: - ImageBanner Collection

extension ProductDetailsPresenter {
    func imageBannerRequest(for indexPath: IndexPath) -> String {
        images[indexPath.row]
    }
    
    func getImageBannerCount() -> Int {
        images.count
    }
}

// MARK: - Color Collection

extension ProductDetailsPresenter {
    func colorRequest(for indexPath: IndexPath) -> String {
        colors[indexPath.row]
    }
    
    func getColorCount() -> Int {
        colors.count
    }
}

// MARK: - Capacity Collection

extension ProductDetailsPresenter {
    func capacityRequest(for indexPath: IndexPath) -> String {
        capacity[indexPath.row]
    }
    
    func getCapacityCount() -> Int {
        capacity.count
    }
}

// MARK: - Tab Bar

extension ProductDetailsPresenter {
    func toggleTabBarAppearance() {
        NotificationCenter.default.post(
            name: NSNotification.Name(R.Text.NotificationKey.tabBar),
            object: nil
        )
    }
}

// MARK: - Data

private extension ProductDetailsPresenter {
    func fetchData() {
        networkService.fetchData(
            with: R.Text.Url.productDetails,
            for: ProductDetailsModel.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.viewModel = data
                self.receiveViewModel()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func receiveViewModel() {
        images = viewModel?.images ?? []
        colors = viewModel?.color ?? []
        capacity = viewModel?.capacity ?? []
        view.receiveData(for: viewModel)
    }
}
