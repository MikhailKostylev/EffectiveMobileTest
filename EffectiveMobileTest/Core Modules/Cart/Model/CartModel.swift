//
//  CartModel.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 18.12.2022.
//

import Foundation

struct CartModel: Codable {
    var basket: [Basket]
    let delivery, id: String
    let total: Int
}

struct Basket: Codable {
    let id: Int
    let images: String
    let price: Int
    let title: String
    var count: Int? = 1
}
