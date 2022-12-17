//
//  CategoryCellViewModel.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 11.12.2022.
//

import UIKit

protocol CategoryCellViewModelProtocol: AnyObject {
    var image: UIImage { get }
    var name: String { get }
    var isSelected: Bool { get set }
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    var image: UIImage
    var name: String
    var isSelected: Bool
    
    init(image: UIImage, name: String, isSelected: Bool = false) {
        self.image = image
        self.name = name
        self.isSelected = isSelected
    }
}
