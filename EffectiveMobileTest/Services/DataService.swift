//
//  DataService.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 08.12.2022.
//

import Foundation

protocol DataServiceProtocol {
    func getCategories() -> [CategoryCellViewModelProtocol]
    func getBrands() -> [String]
    func getPrices() -> [String]
    func getSizes() -> [String]
}

struct DataService: DataServiceProtocol {
    public func getCategories() -> [CategoryCellViewModelProtocol] {
        return [
            CategoryCellViewModel(image: R.Image.Home.phones, name: R.Text.Home.phones),
            CategoryCellViewModel(image: R.Image.Home.computer, name: R.Text.Home.computer),
            CategoryCellViewModel(image: R.Image.Home.health, name: R.Text.Home.health),
            CategoryCellViewModel(image: R.Image.Home.books, name: R.Text.Home.books),
            CategoryCellViewModel(image: R.Image.Home.products, name: R.Text.Home.products)
        ]
    }
    
    public func getBrands() -> [String] {
        ["Samsung", "Apple", "Xiaomi", "Huawei", "Realme"]
    }
    
    public func getPrices() -> [String] {
        ["$300 - $500", "$500 - $1000", "$1000 - $2000", "$2000 - $5000", "$5000 - $10000"]
    }
    
    public func getSizes() -> [String] {
        ["4.5 to 5.5 inches", "5.5 to 7.2 inches", "7.2 to 12.5 inches", "12.5 to 16.5 inches", "16.5 to 24.7 inches"]
    }
}
