//
//  ProductDetailsModel.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 15.12.2022.
//

import Foundation

struct ProductDetailsModel: Codable {
    let cpu, camera: String
    let capacity, color: [String]
    let id: String
    let images: [String]
    var isFavorites: Bool
    let price: Int
    let rating: Double
    let sd, ssd, title: String

    enum CodingKeys: String, CodingKey {
        case cpu = "CPU"
        case camera, capacity, color, id, images, isFavorites, price, rating, sd, ssd, title
    }
}
