//
//  Int+Ext.swift
//  EffectiveMobileTest
//
//  Created by Mikhail Kostylev on 14.12.2022.
//

import Foundation

extension Int {
    func convertToDollars() -> String? {
        let strPrice = String(self)
        var strArray = strPrice.map { String($0) }
        guard strArray.count > 3 else { return "$\(self)" }
        let index = strArray.count == 4 ? 1 : 2
        strArray.insert(",", at: index)
        return "$\(strArray.joined())"
    }
    
    func convertToDollarsWithCents() -> String? {
        let strPrice = String(self)
        var strArray = strPrice.map { String($0) }
        guard strArray.count > 3 else { return "$\(self)" }
        let index = strArray.count == 4 ? 1 : 2
        strArray.insert(",", at: index)
        return "$\(strArray.joined()).00"
    }
    
    func convertToDollarsUS() -> String? {
        let strPrice = String(self)
        var strArray = strPrice.map { String($0) }
        guard strArray.count > 3 else { return "$\(self)" }
        let index = strArray.count == 4 ? 1 : 2
        strArray.insert(",", at: index)
        return "$\(strArray.joined()) us"
    }
}
